#!/usr/bin/env bash
# Test script for scripts/release/approve.sh
#
# `gh` is stubbed on PATH so nothing here touches the network or the real
# repository. The stub is driven by GH_STUB_* variables and records any POST
# body it is handed, which is how the tests below tell "would have approved"
# apart from "approved nothing".

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

STUB_DIR="$(mktemp -d)"
trap 'rm -rf "$STUB_DIR"' EXIT

cat >"$STUB_DIR/gh" <<'STUB'
#!/usr/bin/env bash
case "$1" in
run) printf '%s\n' "${GH_STUB_WAITING:-[]}" ;;
repo) printf '%s\n' "${GH_STUB_REPO:-michen00/custom-commit-hooks}" ;;
release) printf '%s\n' "${GH_STUB_LATEST:-v0.1.2}" ;;
pr) printf '%s\n' "${GH_STUB_OPENPR:-}" ;;
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
chmod +x "$STUB_DIR/gh"

WAITING_RUN='[{"databaseId":42,"headBranch":"release/v9.9.9","headSha":"abc123","url":"https://example.invalid/run/42"}]'
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

log="$STUB_DIR/post1.log"
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

out="$(GH_STUB_WAITING='[]' run_approve "$log" --status)"
status=$?
if [ "$status" -ne 0 ]; then
	fail "--status exits 0 when idle" "Exited $status, expected 0"
elif [[ "$out" != *"Awaiting approval: none"* ]]; then
	fail "--status reports an idle repository" "Got: $out"
else
	pass "--status exits 0 and reports nothing awaiting approval"
fi

# --- status with a run in flight ---------------------------------------------

out="$(GH_STUB_WAITING="$WAITING_RUN" run_approve "$log" --status)"
if [[ "$out" == *"v9.9.9"* && "$out" == *"https://example.invalid/run/42"* ]]; then
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
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_PENDING="$PENDING_OK" \
	run_approve "$log")"
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
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_PENDING="$PENDING_DENIED" \
	run_approve "$log" --yes)"
status=$?
if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
	pass "a non-approver is rejected without a POST"
else
	fail "a non-approver is rejected" "Exited $status; log $([ -s "$log" ] && echo "non-empty" || echo "empty")"
fi

: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_PENDING='[]' \
	run_approve "$log" --yes)"
status=$?
if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
	pass "a waiting run with no pending deployment is rejected"
else
	fail "no pending deployment is rejected" "Exited $status"
fi

# A branch name reaches this script from a merged pull request, so it is
# attacker-influenced in the same way the workflows' inputs are.
: >"$log"
INJECT='[{"databaseId":42,"headBranch":"release/v1.0.0; rm -rf /","headSha":"abc","url":"u"}]'
out="$(GH_STUB_WAITING="$INJECT" GH_STUB_PENDING="$PENDING_OK" \
	run_approve "$log" --yes)"
status=$?
if [ "$status" -eq 1 ] && [ ! -s "$log" ]; then
	pass "a branch that is not a clean vX.Y.Z is rejected"
else
	fail "malformed branch is rejected" "Exited $status"
fi

# --- the approving path ------------------------------------------------------

: >"$log"
out="$(GH_STUB_WAITING="$WAITING_RUN" GH_STUB_PENDING="$PENDING_OK" \
	run_approve "$log" --yes)"
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

printf "\nResults: ${GREEN}%d passed${NC}, ${RED}%d failed${NC}\n" "$PASSED" "$FAILED"

[ "$FAILED" -eq 0 ]
