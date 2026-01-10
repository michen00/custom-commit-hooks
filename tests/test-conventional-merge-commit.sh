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

# === CSV-driven tests (720 cases, parallelized) ===
CSV_FILE="$TEST_SCRIPT_DIR/test-conventional-merge-commit.csv"
CSV_COUNT=$(($(wc -l <"$CSV_FILE") - 1)) # Subtract header

echo "Running $CSV_COUNT CSV test cases in parallel..."

# Track failures across parallel jobs
FAIL_FLAG=$(mktemp)
rm -f "$FAIL_FLAG" # Remove so we can check existence
trap 'rm -f "$FAIL_FLAG"' EXIT

MAX_JOBS=8
job_count=0

# Read CSV preserving whitespace (skip header)
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
			wait -n 2>/dev/null || true # Wait for any job (bash 4.3+)
			job_count=$((job_count - 1))
		fi

		# Early termination check
		if [ -f "$FAIL_FLAG" ]; then
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
trap 'rm -rf "$CMC_TEMP_DIR"; rm -f "$FAIL_FLAG"' EXIT

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

echo ""
echo -e "Results: ${GREEN}${PASSED} passed${NC}, ${RED}${FAILED} failed${NC}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
