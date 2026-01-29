#!/usr/bin/env bash
# Test script for conventional-merge-commit hook

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared configurations and helpers
# shellcheck disable=SC1091 # Dynamic path via $TEST_SCRIPT_DIR
. "$TEST_SCRIPT_DIR/colors.sh"
# shellcheck disable=SC1091
. "$TEST_SCRIPT_DIR/conventional-merge-commit-helper.sh"

printf "Testing conventional-merge-commit hook...\n\n"

# === CSV-driven tests (auto-counted, parallelized) ===
CSV_FILE="$TEST_SCRIPT_DIR/test-conventional-merge-commit.csv"
CSV_COUNT=$(($(wc -l <"$CSV_FILE") - 1)) # Subtract header

echo "Running $CSV_COUNT CSV test cases in parallel..."

# Track failures across parallel jobs
FAIL_FLAG=$(mktemp)
rm -f "$FAIL_FLAG" # Remove so we can check existence

# Kill background jobs using POSIX-compatible commands (script still requires bash; no xargs -r which is GNU-specific)
# shellcheck disable=SC2317 # Called via trap and early termination
kill_jobs() {
	local pids
	pids=$(jobs -p 2>/dev/null) || true
	if [ -n "$pids" ]; then
		# shellcheck disable=SC2086 # Word splitting intended for PIDs
		kill $pids 2>/dev/null || true
	fi
}

# Cleanup function to kill background jobs and remove temp files
# shellcheck disable=SC2329 # Called via trap
cleanup() {
	kill_jobs
	rm -f "$FAIL_FLAG"
}
trap cleanup EXIT

MAX_JOBS=8
job_count=0

# Check if wait -n is available (bash 4.3+)
# On older bash, we fall back to batch processing
has_wait_n() {
	[ "${BASH_VERSINFO[0]}" -gt 4 ] ||
		{ [ "${BASH_VERSINFO[0]}" -eq 4 ] && [ "${BASH_VERSINFO[1]}" -ge 3 ]; }
}

# Read CSV preserving whitespace (skip header)
# Note: this simple parser will break if cells contain commas.
# If you need commas in fields, either:
#   - introduce an escape convention in the CSV (e.g., '\,' for literal commas)
#     and add a small unescape step after `read`, or
#   - switch the test data to use a different delimiter and update IFS accordingly.
{
	read -r # Skip header
	while IFS=, read -r original transformed; do
		# Launch test in background
		(
			tmp_file=$(mktemp)
			trap 'rm -f "$tmp_file"' EXIT

			printf '%s' "$original" >"$tmp_file"
			"$HOOK_MERGE" "$tmp_file" "merge" >/dev/null 2>&1 || true

			actual=$(head -n 1 "$tmp_file")

			if [ "$actual" != "$transformed" ]; then
				echo -e "${RED}✗${NC} '$original' -> expected '$transformed', got '$actual'" >&2
				touch "$FAIL_FLAG"
				exit 1
			fi
		) &

		job_count=$((job_count + 1))

		# Limit concurrent jobs
		if [ "$job_count" -ge "$MAX_JOBS" ]; then
			if has_wait_n; then
				wait -n # Wait for any single job (bash 4.3+)
				job_count=$((job_count - 1))
			else
				# Fallback: wait for all jobs in batch, then reset
				wait
				job_count=0
			fi
		fi

		# Early termination: stop launching new jobs and kill running ones
		if [ -f "$FAIL_FLAG" ]; then
			kill_jobs
			break
		fi
	done
} <"$CSV_FILE"

# Wait for remaining jobs
wait

if [ -f "$FAIL_FLAG" ]; then
	echo -e "${RED}CSV tests failed${NC}"
	exit 1
fi

echo -e "${GREEN}✓${NC} All $CSV_COUNT CSV tests passed"
echo ""

# === Manual edge case tests (sequential, with counting) ===
PASSED=$CSV_COUNT
FAILED=0

# Set up temp directory for manual tests
CMC_TEMP_DIR=$(mktemp -d)
# shellcheck disable=SC2034 # CMC_MSG_FILE is used by sourced helper
CMC_MSG_FILE="$CMC_TEMP_DIR/COMMIT_EDITMSG"
trap 'cleanup; rm -rf "$CMC_TEMP_DIR"' EXIT

echo "=== Manual edge case tests ==="
echo ""

# === Messages that should NOT be modified ===
test_conventional_merge_commit \
	"'Merging' unchanged (not a merge keyword)" \
	"Merging .+" \
	"merge" \
	"Merging .+"

test_conventional_merge_commit \
	"'merging' unchanged (not a merge keyword)" \
	"merging .+" \
	"merge" \
	"merging .+"

test_conventional_merge_commit \
	"'Squashing' unchanged (not a squash keyword)" \
	"Squashing .+" \
	"merge" \
	"Squashing .+"

test_conventional_merge_commit \
	"'squashing' unchanged (not a squash keyword)" \
	"squashing .+" \
	"merge" \
	"squashing .+"

test_conventional_merge_commit \
	"'Reverting' unchanged (not a revert keyword)" \
	"Reverting .+" \
	"revert" \
	"Reverting .+"

test_conventional_merge_commit \
	"'reverting' unchanged (not a revert keyword)" \
	"reverting .+" \
	"revert" \
	"reverting .+"

test_conventional_merge_commit \
	"'Reapplying' unchanged (not a reapply keyword)" \
	"Reapplying .+" \
	"revert" \
	"Reapplying .+"

test_conventional_merge_commit \
	"'reapplying' unchanged (not a reapply keyword)" \
	"reapplying .+" \
	"revert" \
	"reapplying .+"

test_conventional_merge_commit \
	"Non-merge commit source short-circuits (no message read)" \
	"Merge branch" \
	"commit" \
	"Merge branch"

test_conventional_merge_commit \
	"Auto-detection transforms merge message" \
	"chore: merge branch" \
	"" \
	"Merge branch"

test_conventional_merge_commit \
	"Auto-detect: 'Squash commits' transforms" \
	"chore: squash commits" \
	"" \
	"Squash commits"

test_conventional_merge_commit \
	"Auto-detect: 'Revert commit' transforms" \
	"revert: revert commit" \
	"" \
	"Revert commit"

test_conventional_merge_commit \
	"Auto-detect: 'Reapply commit' transforms" \
	"revert: reapply commit" \
	"" \
	"Reapply commit"

test_conventional_merge_commit \
	"Auto-detect: non-trigger word unchanged" \
	"Regular commit message" \
	"" \
	"Regular commit message"

# === Squash commit source ===
test_conventional_merge_commit \
	"Squash commit source transforms message" \
	"chore: squashed commits" \
	"squash" \
	"Squashed commits"

# === Revert commit source ===
test_conventional_merge_commit \
	"Revert commit source transforms message" \
	"revert: revert commit abc123" \
	"revert" \
	"Revert commit abc123"

test_conventional_merge_commit \
	"Reapply commit source transforms message" \
	"revert: reapply commit abc123" \
	"revert" \
	"Reapply commit abc123"

# === Git revert --no-edit case (commit_source="message") ===
test_conventional_merge_commit \
	"Revert with 'message' source transforms (git revert --no-edit)" \
	"revert: revert commit abc123" \
	"message" \
	"Revert commit abc123"

test_conventional_merge_commit \
	"Reapply with 'message' source transforms (git revert --no-edit)" \
	"revert: reapply commit abc123" \
	"message" \
	"Reapply commit abc123"

# === Body preservation tests ===
test_conventional_merge_commit \
	"Multi-line merge preserves body" \
	"chore: merge branch 'feature'" \
	"merge" \
	"Merge branch 'feature'

This merges the feature branch with detailed notes." \
	"This merges the feature branch with detailed notes."

test_conventional_merge_commit \
	"Multi-line squash preserves body" \
	"chore: squash branch 'feature'" \
	"squash" \
	"Squash branch 'feature'

* commit 1
* commit 2" \
	"* commit 1
* commit 2"

test_conventional_merge_commit \
	"Multi-line revert preserves body" \
	"revert: revert commit abc123" \
	"revert" \
	"Revert commit abc123

This reverts commit abc123 which introduced a bug." \
	"This reverts commit abc123 which introduced a bug."

test_conventional_merge_commit \
	"Multi-line reapply preserves body" \
	"revert: reapply commit abc123" \
	"revert" \
	"Reapply commit abc123

This reapplies commit abc123 after fixing the issue." \
	"This reapplies commit abc123 after fixing the issue."

# === Word boundary tests ===
test_conventional_merge_commit \
	"'Merge_branch' unchanged (underscore is word char)" \
	"Merge_branch" \
	"merge" \
	"Merge_branch"

test_conventional_merge_commit \
	"'Squash_commits' unchanged (underscore is word char)" \
	"Squash_commits" \
	"squash" \
	"Squash_commits"

test_conventional_merge_commit \
	"'Revert_commit' unchanged (underscore is word char)" \
	"Revert_commit" \
	"revert" \
	"Revert_commit"

test_conventional_merge_commit \
	"'Reapply_commit' unchanged (underscore is word char)" \
	"Reapply_commit" \
	"revert" \
	"Reapply_commit"

echo ""
echo -e "Results: ${GREEN}${PASSED} passed${NC}, ${RED}${FAILED} failed${NC}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
