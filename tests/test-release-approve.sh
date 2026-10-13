#!/usr/bin/env bash
# Test script for scripts/release/approve.sh
#
# `gh` is stubbed on PATH so nothing here touches the network or the real
# repository. The stub is driven by GH_STUB_* variables and records any POST
# body it is handed, with the endpoint it was sent to, which is how the tests
# below tell "would have approved" apart from "approved nothing", and which run
# an approval went to.
#
# Setup below is fail-fast and ends by asserting the stub is what `gh` actually
# resolves to. That assertion is not ceremony: if mktemp or chmod failed and the
# suite carried on, `--yes` cases would reach the caller's authenticated gh and
# POST a real approval against whatever release happened to be waiting.

set -uo pipefail
# The cases below set these when they mean to; a value exported by the caller
# would otherwise slow every case down or fail it outright.
unset RELEASE_APPROVE_TIMEOUT RELEASE_APPROVE_INTERVAL
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
run)
	if [ "$2" = "view" ]; then
		# approve.sh asks for "<status> <conclusion>" through --jq.
		printf '%s\n' "${GH_STUB_TAG_STATE:-in_progress null}"
		exit 0
	fi
	case " $* " in
	*" --workflow=release-publish.yml "*)
		# GH_STUB_PUBLISH_AFTER=N hides the publish run from the first N
		# listings, which is how a run that appears mid-wait is simulated.
		calls=0
		if [ -n "${GH_STUB_COUNTER:-}" ]; then
			calls="$(cat "$GH_STUB_COUNTER" 2>/dev/null || echo 0)"
			echo $((calls + 1)) >"$GH_STUB_COUNTER"
		fi
		if [ "$calls" -lt "${GH_STUB_PUBLISH_AFTER:-0}" ]; then
			echo '[]'
		else
			printf '%s\n' "${GH_STUB_PUBLISH_WAITING:-[]}"
		fi
		;;
	*) printf '%s\n' "${GH_STUB_WAITING:-[]}" ;;
	esac
	;;
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
	endpoint=""
	for arg in "$@"; do
		case "$arg" in repos/*) endpoint="$arg" ;; esac
	done
	for arg in "$@"; do
		if [ "$arg" = "POST" ]; then
			jq -c --arg endpoint "$endpoint" '. + {endpoint: $endpoint}' \
				>>"${GH_STUB_POST_LOG:-/dev/null}"
			echo '{}'
			exit 0
		fi
	done
	case "$endpoint" in
	*/commits/refs/tags/*)
		[ -n "${GH_STUB_TAG_SHA:-}" ] || exit 1
		printf '%s\n' "$GH_STUB_TAG_SHA"
		;;
	*) printf '%s\n' "${GH_STUB_PENDING:-[]}" ;;
	esac
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
PUBLISH_RUN='[{"databaseId":43,"displayTitle":"Release Publish v9.9.9","event":"workflow_dispatch","headBranch":"main","url":"https://example.invalid/run/43"}]'
OTHER_PUBLISH_RUN='[{"databaseId":44,"displayTitle":"Release Publish v9.9.8","event":"workflow_dispatch","headBranch":"main","url":"https://example.invalid/run/44"}]'
UNNAMED_PUBLISH_RUN='[{"databaseId":45,"displayTitle":"Release Publish","event":"workflow_dispatch","headBranch":"main","url":"https://example.invalid/run/45"}]'
# A run's name comes from its own workflow file, read from the ref it started
# on, so these name v9.9.9 without being runs a maintainer has vouched for.
BRANCH_PUBLISH_RUN='[{"databaseId":46,"displayTitle":"Release Publish v9.9.9","event":"workflow_dispatch","headBranch":"feature","url":"https://example.invalid/run/46"}]'
FOREIGN_TAG_PUBLISH_RUN='[{"databaseId":47,"displayTitle":"Release Publish v9.9.9","event":"push","headBranch":"v9.9.10","url":"https://example.invalid/run/47"}]'
TAG_PUSH_PUBLISH_RUN='[{"databaseId":48,"displayTitle":"Release Publish v9.9.9","event":"push","headBranch":"v9.9.9","url":"https://example.invalid/run/48"}]'
TAG_SHA="cccccccccccccccccccccccccccccccccccccccc"
PENDING_OK='[{"environment":{"id":7,"name":"release"},"current_user_can_approve":true}]'
PENDING_DENIED='[{"environment":{"id":7,"name":"release"},"current_user_can_approve":false}]'
PENDING_EXTRA='[{"environment":{"id":7,"name":"release"},"current_user_can_approve":true},{"environment":{"id":8,"name":"other"},"current_user_can_approve":true}]'

# run_approve <post_log> [args...] -- runs approve.sh with the stub on PATH.
# Stdin is /dev/null so the confirmation prompt's terminal check is deterministic.
# The wait for Release Publish defaults to a single look, so a case that never
# supplies the publish run fails at once instead of after five minutes.
run_approve() {
	local log="$1"
	shift
	GH_STUB_POST_LOG="$log" PATH="$STUB_DIR:$PATH" \
		RELEASE_APPROVE_TIMEOUT="${RELEASE_APPROVE_TIMEOUT:-0}" \
		RELEASE_APPROVE_INTERVAL="${RELEASE_APPROVE_INTERVAL:-1}" \
		sh "$APPROVE" "$@" </dev/null 2>&1
}

# approved_runs <post_log> -- the run ids approved, in order, space-separated.
approved_runs() {
	jq -rs 'map(.endpoint | capture("runs/(?<id>[0-9]+)/").id) | join(" ")' "$1"
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
	GH_STUB_PENDING="$PENDING_OK" GH_STUB_PUBLISH_WAITING="$PUBLISH_RUN" \
	GH_STUB_COUNTER="$STUB_DIR/counter.1" GH_STUB_PUBLISH_AFTER=1 \
	run_approve "$log" --yes)"
status=$?
if [ "$status" -ne 0 ]; then
	fail "--yes approves" "Exited $status, expected 0. Output: $out"
elif [ ! -s "$log" ]; then
	fail "--yes sends an approval" "No POST was recorded"
else
	if [[ "$(jq -rs 'map(.state) | unique | join(",")' "$log")" == "approved" ]] &&
		[[ "$(jq -cs 'map(.environment_ids) | unique' "$log")" == "[[7]]" ]]; then
		pass "--yes POSTs state=approved for the pending environment"
	else
		fail "--yes POSTs the right body" "Got: $(cat "$log")"
	fi
fi

# Release Publish waits on the same environment, so a release is not out until
# both runs are approved -- the tag first, then the publish run it dispatched.
runs="$(approved_runs "$log")"
if [ "$runs" = "42 43" ]; then
	pass "approves Release Tag, then the Release Publish run for the same tag"
else
	fail "approves both release runs in order" "Approved: '$runs'. Output: $out"
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

# --- waiting for Release Publish ---------------------------------------------

# The publish run appears only after Release Tag has pushed the tag, so the
# usual case is that it is absent at first and shows up on a later look. By
# then Release Tag has dispatched it and finished, so a successful conclusion
# must keep the wait going rather than end it.
: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PENDING="$PENDING_OK" GH_STUB_PUBLISH_WAITING="$PUBLISH_RUN" \
	GH_STUB_COUNTER="$STUB_DIR/counter.2" GH_STUB_PUBLISH_AFTER=2 \
	GH_STUB_TAG_STATE="completed success" \
	RELEASE_APPROVE_TIMEOUT=5 run_approve "$log" --yes)"
status=$?
runs="$(approved_runs "$log")"
if [ "$status" -eq 0 ] && [ "$runs" = "42 43" ]; then
	pass "keeps looking until the Release Publish run appears"
else
	fail "waits for a late Release Publish run" \
		"Exited $status. Approved: '$runs'. Output: $out"
fi

: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PENDING="$PENDING_OK" run_approve "$log" --yes)"
status=$?
runs="$(approved_runs "$log")"
if [ "$status" -eq 1 ] && [ "$runs" = "42" ] && [[ "$out" == *"run this again"* ]]; then
	pass "a Release Publish run that never appears fails after the tag, saying what to do"
else
	fail "times out waiting for Release Publish" \
		"Exited $status. Approved: '$runs'. Output: $out"
fi

# A failed Release Tag dispatches nothing, so waiting out the timeout would only
# delay the bad news. The timeout here is long enough to tell the two apart.
: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PENDING="$PENDING_OK" GH_STUB_TAG_STATE="completed failure" \
	RELEASE_APPROVE_TIMEOUT=2 run_approve "$log" --yes)"
status=$?
runs="$(approved_runs "$log")"
if [ "$status" -eq 1 ] && [ "$runs" = "42" ] && [[ "$out" == *"without success"* ]]; then
	pass "stops waiting when Release Tag fails"
else
	fail "stops waiting when Release Tag fails" \
		"Exited $status. Approved: '$runs'. Output: $out"
fi

# The confirmation named one tag; a publish run for any other is not covered.
: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PENDING="$PENDING_OK" GH_STUB_PUBLISH_WAITING="$OTHER_PUBLISH_RUN" \
	GH_STUB_COUNTER="$STUB_DIR/counter.3" GH_STUB_PUBLISH_AFTER=1 \
	run_approve "$log" --yes)"
status=$?
runs="$(approved_runs "$log")"
if [ "$status" -eq 1 ] && [ "$runs" = "42" ] && [[ "$out" == *"v9.9.8"* ]]; then
	pass "never approves a Release Publish run for a different tag"
else
	fail "refuses a Release Publish run for another tag" \
		"Exited $status. Approved: '$runs'. Output: $out"
fi

# The one confirmation covered the dispatch Release Tag makes, on main. A run
# that merely names the same tag is not that run.
: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PENDING="$PENDING_OK" GH_STUB_PUBLISH_WAITING="$BRANCH_PUBLISH_RUN" \
	GH_STUB_COUNTER="$STUB_DIR/counter.4" GH_STUB_PUBLISH_AFTER=1 \
	run_approve "$log" --yes)"
status=$?
runs="$(approved_runs "$log")"
if [ "$status" -eq 1 ] && [ "$runs" = "42" ] && [[ "$out" == *"not dispatched on main"* ]]; then
	pass "never approves a same-named Release Publish run dispatched from another branch"
else
	fail "refuses a publish run from another branch after the tag" \
		"Exited $status. Approved: '$runs'. Output: $out"
fi

: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PENDING="$PENDING_EXTRA" run_approve "$log" --yes)"
status=$?
if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
	pass "a run waiting on more than the release environment is rejected"
else
	fail "extra environments are rejected" "Exited $status. Got: $out"
fi

# --- a Release Publish run already waiting ------------------------------------

: >"$log"
out="$(GH_STUB_PUBLISH_WAITING="$PUBLISH_RUN" GH_STUB_TAG_SHA="$TAG_SHA" \
	GH_STUB_PENDING="$PENDING_OK" run_approve "$log" --yes)"
status=$?
runs="$(approved_runs "$log")"
if [ "$status" -ne 0 ] || [ "$runs" != "43" ]; then
	fail "approves a waiting Release Publish run" \
		"Exited $status. Approved: '$runs'. Output: $out"
elif [[ "$out" == *"v9.9.9"* && "$out" == *"$TAG_SHA"* ]]; then
	pass "approves a waiting Release Publish run, naming its tag and commit"
else
	fail "the publish summary names the tag and commit" "Got: $out"
fi

: >"$log"
out="$(GH_STUB_PUBLISH_WAITING="$PUBLISH_RUN" GH_STUB_PENDING="$PENDING_OK" \
	run_approve "$log" --yes)"
status=$?
if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
	pass "a Release Publish run for a tag that does not resolve is rejected"
else
	fail "unresolvable publish tag is rejected" "Exited $status. Got: $out"
fi

: >"$log"
out="$(GH_STUB_PUBLISH_WAITING="$UNNAMED_PUBLISH_RUN" GH_STUB_TAG_SHA="$TAG_SHA" \
	GH_STUB_PENDING="$PENDING_OK" run_approve "$log" --yes)"
status=$?
if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
	pass "a Release Publish run whose name gives no tag is rejected"
else
	fail "unnamed publish run is rejected" "Exited $status. Got: $out"
fi

# An older release's publish run goes first: approving the new tag would only
# queue its publish run behind it.
: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
	GH_STUB_PUBLISH_WAITING="$OTHER_PUBLISH_RUN" GH_STUB_TAG_SHA="$TAG_SHA" \
	GH_STUB_PENDING="$PENDING_OK" run_approve "$log" --yes)"
status=$?
runs="$(approved_runs "$log")"
if [ "$status" -eq 0 ] && [ "$runs" = "44" ] && [[ "$out" == *"run this again"* ]]; then
	pass "a waiting Release Publish run is approved before a waiting Release Tag run"
else
	fail "approves the waiting publish run first" \
		"Exited $status. Approved: '$runs'. Output: $out"
fi

: >"$log"
out="$(GH_STUB_PUBLISH_WAITING="$PUBLISH_RUN" GH_STUB_TAG_SHA="$TAG_SHA" \
	GH_STUB_PENDING="$PENDING_OK" run_approve "$log")"
status=$?
if [ "$status" -eq 1 ] && [[ "$out" == *"not a terminal"* ]] && [ ! -s "$log" ]; then
	pass "a waiting Release Publish run is not approved unprompted without --yes"
else
	fail "the publish path asks for confirmation" "Exited $status. Got: $out"
fi

: >"$log"
out="$(GH_STUB_PUBLISH_WAITING="$PUBLISH_RUN" GH_STUB_TAG_SHA="$TAG_SHA" \
	GH_STUB_PENDING="$PENDING_DENIED" run_approve "$log" --yes)"
status=$?
if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
	pass "a non-approver cannot approve a waiting Release Publish run"
else
	fail "a non-approver is rejected on the publish path" "Exited $status"
fi

for case_run in "$BRANCH_PUBLISH_RUN" "$FOREIGN_TAG_PUBLISH_RUN"; do
	: >"$log"
	out="$(GH_STUB_PUBLISH_WAITING="$case_run" GH_STUB_TAG_SHA="$TAG_SHA" \
		GH_STUB_PENDING="$PENDING_OK" run_approve "$log" --yes)"
	status=$?
	origin="$(jq -r '.[0] | "\(.event) \(.headBranch)"' <<<"$case_run")"
	if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
		pass "a Release Publish run started by '$origin' is rejected"
	else
		fail "a publish run started by '$origin' is rejected" \
			"Exited $status. Got: $out"
	fi
done

: >"$log"
out="$(GH_STUB_PUBLISH_WAITING="$TAG_PUSH_PUBLISH_RUN" GH_STUB_TAG_SHA="$TAG_SHA" \
	GH_STUB_PENDING="$PENDING_OK" run_approve "$log" --yes)"
status=$?
runs="$(approved_runs "$log")"
if [ "$status" -eq 0 ] && [ "$runs" = "48" ] && [[ "$out" == *"push on v9.9.9"* ]]; then
	pass "a Release Publish run started by a push of its own tag is approved"
else
	fail "approves the run a hand-pushed tag starts" \
		"Exited $status. Approved: '$runs'. Output: $out"
fi

for bad in 08 abc; do
	: >"$log"
	out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_MERGEDPR="$MERGED_PR" \
		GH_STUB_PENDING="$PENDING_OK" RELEASE_APPROVE_INTERVAL="$bad" \
		run_approve "$log" --yes)"
	status=$?
	if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
		pass "RELEASE_APPROVE_INTERVAL=$bad is refused before anything is approved"
	else
		fail "RELEASE_APPROVE_INTERVAL=$bad is refused up front" \
			"Exited $status. Got: $out"
	fi
done

out="$(GH_STUB_PUBLISH_WAITING="$PUBLISH_RUN" GH_STUB_RELEASES='[]' \
	run_approve "$log" --status)"
status=$?
if [ "$status" -eq 0 ] && [[ "$out" == *"v9.9.9 publish"* && "$out" == *"https://example.invalid/run/43"* ]]; then
	pass "--status reports a Release Publish run awaiting approval"
else
	fail "--status reports a waiting publish run" "Exited $status. Got: $out"
fi

printf "\nResults: ${GREEN}%d passed${NC}, ${RED}%d failed${NC}\n" "$PASSED" "$FAILED"

[ "$FAILED" -eq 0 ]
