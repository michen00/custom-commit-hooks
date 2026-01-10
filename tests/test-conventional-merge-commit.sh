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
	"Non-merge commit source unchanged" \
	"Merge branch" \
	"commit" \
	"Merge branch"

test_conventional_merge_commit \
	"Empty commit source unchanged" \
	"Merge branch" \
	"" \
	"Merge branch"

# === Squash commit source ===
test_conventional_merge_commit \
	"Squash commit source transforms message" \
	"chore: squashed commits" \
	"squash" \
	"Squashed commits"

echo ""
echo -e "Results: ${GREEN}${PASSED} passed${NC}, ${RED}${FAILED} failed${NC}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
