#!/usr/bin/env bash
# Test script for scripts/release/approve.sh
#
# `gh` is stubbed on PATH so nothing here touches the network or the real
# repository. The stub is driven by GH_STUB_* variables and records any POST
# body it is handed, which is how the tests below tell "would have approved"
# apart from "approved nothing".
#
# Setup below is fail-fast and ends by asserting the stub is what `gh` actually
# resolves to. That assertion is not ceremony: if mktemp or chmod failed and the
# suite carried on, `--yes` cases would reach the caller's authenticated gh and
# POST a real approval against whatever release happened to be waiting.

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared configurations
# shellcheck disable=SC1091 # Dynamic path via $TEST_SCRIPT_DIR
. "$TEST_SCRIPT_DIR/colors.sh"

APPROVE="$TEST_SCRIPT_DIR/../scripts/release/approve.sh"

PASSED=0
FAILED=0

pass() {
	echo -e "${GREEN}✓${NC} $1"
	((PASSED++))
}

fail() {
	echo -e "${RED}✗${NC} $1"
	shift
	for msg in "$@"; do
		echo -e "  ${YELLOW}$msg${NC}"
	done
	((FAILED++))
}

setup_failed() {
	echo -e "${RED}✗${NC} test setup failed: $1" >&2
	exit 1
}

STUB_DIR="$(mktemp -d)" || setup_failed "mktemp -d"
trap 'rm -rf "$STUB_DIR"' EXIT

cat >"$STUB_DIR/gh" <<'STUB' || setup_failed "writing the gh stub"
#!/usr/bin/env bash
case "$1" in
run) printf '%s\n' "${GH_STUB_WAITING:-[]}" ;;
repo) printf '%s\n' "${GH_STUB_REPO:-michen00/custom-commit-hooks}" ;;
release)
	[ -n "${GH_STUB_RELEASE_FAIL:-}" ] && exit 1
	printf '%s\n' "${GH_STUB_RELEASES:-[]}"
	;;
pr)
	for arg in "$@"; do
		if [ "$arg" = "merged" ]; then
			printf '%s\n' "${GH_STUB_MERGEDPR:-[]}"
			exit 0
		fi
	done
	[ -n "${GH_STUB_OPENPR_FAIL:-}" ] && exit 1
	printf '%s\n' "${GH_STUB_OPENPR:-}"
	;;
api)
	for arg in "$@"; do
		if [ "$arg" = "POST" ]; then
			cat >>"${GH_STUB_POST_LOG:-/dev/null}"
			echo '{}'
			exit 0
		fi
	done
	printf '%s\n' "${GH_STUB_PENDING:-[]}"
	;;
esac
exit 0
STUB

[ -s "$STUB_DIR/gh" ] || setup_failed "gh stub is empty"
chmod +x "$STUB_DIR/gh" || setup_failed "chmod +x on the gh stub"

# The load-bearing guard. Anything short of the stub resolving first means the
# suite would be driving the real GitHub CLI.
resolved="$(PATH="$STUB_DIR:$PATH" command -v gh)"
[ "$resolved" = "$STUB_DIR/gh" ] ||
	setup_failed "gh resolves to '$resolved', not the stub"

# Distinct sentinels: the run reports the release branch tip, but release-tag.yml
# tags the squash merge commit. The summary must name the second, never the first.
BRANCH_TIP="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
MERGE_SHA="bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"

WAITING_RUN="[{\"databaseId\":42,\"headBranch\":\"release/v9.9.9\",\"headSha\":\"$BRANCH_TIP\",\"url\":\"https://example.invalid/run/42\"}]"
MERGED_PR="[{\"number\":83,\"mergeCommit\":{\"oid\":\"$MERGE_SHA\"}}]"
PENDING_OK='[{"environment":{"id":7,"name":"release"},"current_user_can_approve":true}]'
PENDING_DENIED='[{"environment":{"id":7,"name":"release"},"current_user_can_approve":false}]'

# run_approve <post_log> [args...] -- runs approve.sh with the stub on PATH.
# Stdin is /dev/null so the confirmation prompt's terminal check is deterministic.
run_approve() {
	local log="$1"
	shift
	GH_STUB_POST_LOG="$log" PATH="$STUB_DIR:$PATH" \
		sh "$APPROVE" "$@" </dev/null 2>&1
}

# --- argument handling -------------------------------------------------------

PATH="$STUB_DIR:$PATH" sh "$APPROVE" --bogus >/dev/null 2>&1
if [ "$?" -eq 2 ]; then
	pass "unknown flag exits 2"
else
	fail "unknown flag" "Expected exit 2"
fi

# --- nothing waiting ---------------------------------------------------------

log="$STUB_DIR/post.log"
: >"$log"
out="$(GH_STUB_WAITING='[]' run_approve "$log")"
status=$?
if [ "$status" -ne 1 ]; then
	fail "no waiting run exits 1" "Exited $status, expected 1"
elif [[ "$out" != *"Nothing to release"* ]]; then
	fail "no waiting run explains itself" "Got: $out"
elif [ -s "$log" ]; then
	fail "no waiting run approves nothing" "A POST was sent"
else
	pass "no waiting run exits 1 and approves nothing"
fi

# --- status mode -------------------------------------------------------------

out="$(GH_STUB_WAITING='[]' GH_STUB_RELEASES='[{"tagName":"v0.1.2"}]' \
	run_approve "$log" --status)"
status=$?
if [ "$status" -ne 0 ]; then
	fail "--status exits 0 when idle" "Exited $status, expected 0"
elif [[ "$out" != *"Awaiting approval: none"* ]]; then
	fail "--status reports an idle repository" "Got: $out"
elif [[ "$out" != *"v0.1.2"* ]]; then
	fail "--status reports the latest release" "Got: $out"
else
	pass "--status exits 0 and reports nothing awaiting approval"
fi

# An empty release list is a fact about the repository, not a failure.
out="$(GH_STUB_WAITING='[]' GH_STUB_RELEASES='[]' run_approve "$log" --status)"
status=$?
if [ "$status" -eq 0 ] && [[ "$out" == *"Latest release:   none"* ]]; then
	pass "--status reports 'none' for a repository with no releases"
else
	fail "--status handles an empty release list" "Exited $status. Got: $out"
fi

# A failed lookup is not the same fact, and must not read as one.
out="$(GH_STUB_WAITING='[]' GH_STUB_RELEASE_FAIL=1 run_approve "$log" --status)"
status=$?
if [ "$status" -eq 1 ] && [[ "$out" != *"Latest release:   none"* ]]; then
	pass "--status fails loudly when the release lookup errors"
else
	fail "--status distinguishes lookup failure from no releases" \
		"Exited $status. Got: $out"
fi

out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_RELEASES='[]' \
	run_approve "$log" --status)"
status=$?
if [ "$status" -ne 0 ]; then
	fail "--status exits 0 with a run in flight" "Exited $status, expected 0"
elif [[ "$out" == *"v9.9.9"* && "$out" == *"https://example.invalid/run/42"* ]]; then
	pass "--status names the pending version and links the run"
else
	fail "--status names the pending version" "Got: $out"
fi

if [ -s "$log" ]; then
	fail "--status is read-only" "A POST was sent"
else
	pass "--status never approves anything"
fi

# --- refusing to approve -----------------------------------------------------

: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PENDING="$PENDING_OK" run_approve "$log")"
status=$?
if [ "$status" -ne 1 ]; then
	fail "non-tty without --yes exits 1" "Exited $status, expected 1"
elif [[ "$out" != *"not a terminal"* ]]; then
	fail "non-tty without --yes explains itself" "Got: $out"
elif [ -s "$log" ]; then
	fail "non-tty without --yes approves nothing" "A POST was sent"
else
	pass "refuses to approve unprompted without --yes"
fi

: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PENDING="$PENDING_DENIED" run_approve "$log" --yes)"
status=$?
if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
	pass "a non-approver is rejected without a POST"
else
	fail "a non-approver is rejected" "Exited $status"
fi

: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PENDING='[]' run_approve "$log" --yes)"
status=$?
if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
	pass "a waiting run with no pending deployment is rejected"
else
	fail "no pending deployment is rejected" "Exited $status"
fi

# Without a resolvable merge commit there is nothing honest to show, so the
# prompt must not fall back to the branch tip.
: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR='[]' \
	GH_STUB_PENDING="$PENDING_OK" run_approve "$log" --yes)"
status=$?
if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
	pass "an unresolvable merge commit is rejected without a POST"
else
	fail "unresolvable merge commit is rejected" "Exited $status. Got: $out"
fi

# A branch name reaches this script from a merged pull request, so it is
# attacker-influenced in the same way the workflows' inputs are.
: >"$log"
INJECT='[{"databaseId":42,"headBranch":"release/v1.0.0; rm -rf /","headSha":"abc","url":"u"}]'
out="$(GH_STUB_WAITING="$INJECT" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PENDING="$PENDING_OK" run_approve "$log" --yes)"
status=$?
if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
	pass "a branch that is not a clean vX.Y.Z is rejected"
else
	fail "malformed branch is rejected" "Exited $status"
fi

# --- the approving path ------------------------------------------------------

: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PENDING="$PENDING_OK" run_approve "$log" --yes)"
status=$?
if [ "$status" -ne 0 ]; then
	fail "--yes approves" "Exited $status, expected 0. Output: $out"
elif [ ! -s "$log" ]; then
	fail "--yes sends an approval" "No POST was recorded"
else
	body="$(cat "$log")"
	if [[ "$(jq -r '.state' <<<"$body")" == "approved" ]] &&
		[[ "$(jq -c '.environment_ids' <<<"$body")" == "[7]" ]]; then
		pass "--yes POSTs state=approved for the pending environment"
	else
		fail "--yes POSTs the right body" "Got: $body"
	fi
fi

if [[ "$out" == *"v9.9.9"* ]]; then
	pass "the approval summary names the tag being minted"
else
	fail "the approval summary names the tag" "Got: $out"
fi

# The regression that matters: release-tag.yml tags merge_commit_sha, so showing
# the run's headSha would name a commit the tag never points at.
if [[ "$out" == *"$MERGE_SHA"* && "$out" != *"$BRANCH_TIP"* ]]; then
	pass "the summary names the merge commit, not the branch tip"
else
	fail "the summary names the merge commit" \
		"Expected $MERGE_SHA and not $BRANCH_TIP. Got: $out"
fi

printf "\nResults: ${GREEN}%d passed${NC}, ${RED}%d failed${NC}\n" "$PASSED" "$FAILED"

[ "$FAILED" -eq 0 ]
