#!/usr/bin/env bash
# Test script for basic usage

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configurations and helpers
# shellcheck disable=SC1091 # Dynamic path via $TEST_SCRIPT_DIR
. "$TEST_SCRIPT_DIR/colors.sh"
# shellcheck disable=SC1091
. "$TEST_SCRIPT_DIR/enhance-scope-helper.sh"

# Hook paths
HOOK_MERGE="$TEST_SCRIPT_DIR/../scripts/conventional-merge-commit"

PASSED=0
FAILED=0

printf "Testing basic usage of enhance-scope and conventional-merge-commit hooks...\n\n"

# Verifies first line, blank separator line (line 2), body content, exit code for multi-
# line messages (body preservation)
test_conventional_merge_commit_with_body() {
	local test_name="$1"
	local expected_first_line="$2"
	local expected_body="$3"
	local commit_source="$4"
	local input_msg="$5"

	local temp_dir
	temp_dir=$(mktemp -d)
	trap 'rm -rf "$temp_dir"' RETURN

	local msg_file="$temp_dir/COMMIT_EDITMSG"
	printf '%s' "$input_msg" >"$msg_file"

	# Run hook
	local actual_exit=0
	"$HOOK_MERGE" "$msg_file" "$commit_source" >/dev/null 2>&1 || actual_exit=$?

	local actual_first_line
	local actual_blank_line
	local actual_body
	actual_first_line=$(sed -n '1p' "$msg_file")
	actual_blank_line=$(sed -n '2p' "$msg_file")
	actual_body=$(sed -n '3p' "$msg_file")

	local pass=true
	if [ "$actual_first_line" != "$expected_first_line" ]; then pass=false; fi
	if [ -n "$actual_blank_line" ]; then pass=false; fi # Line 2 must be empty
	if [ "$actual_body" != "$expected_body" ]; then pass=false; fi
	if [ "$actual_exit" -ne 0 ]; then pass=false; fi

	if [ "$pass" = true ]; then
		echo -e "${GREEN}✓${NC} $test_name"
		((PASSED++))
	else
		echo -e "${RED}✗${NC} $test_name"
		if [ "$actual_first_line" != "$expected_first_line" ]; then
			echo -e "  Expected first: ${YELLOW}$expected_first_line${NC}"
			echo -e "  Got first:      ${YELLOW}$actual_first_line${NC}"
		fi
		if [ -n "$actual_blank_line" ]; then
			echo -e "  Line 2 should be blank, got: ${YELLOW}$actual_blank_line${NC}"
		fi
		if [ "$actual_body" != "$expected_body" ]; then
			echo -e "  Expected body:  ${YELLOW}$expected_body${NC}"
			echo -e "  Got body:       ${YELLOW}$actual_body${NC}"
		fi
		((FAILED++))
	fi
}

# === Tests ===

test_conventional_merge_commit_with_body \
	"Merge commit body preserved" \
	"chore: merge branch 'feature' into main" \
	"Detailed merge description here" \
	"merge" \
	"Merge branch 'feature' into main

Detailed merge description here
"

test_enhance_scope \
	"Commit body preserved after scope addition" \
	"feat(test.txt): add feature" \
	"echo 'content' > test.txt" \
	"feat: add feature

This is the body
with multiple lines"

echo ""
echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
