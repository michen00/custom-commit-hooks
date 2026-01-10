#!/usr/bin/env bash
# Test helper for conventional-merge-commit hook

HOOK_MERGE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../scripts/conventional-merge-commit"

# Shared temp directory - caller must set up before using:
#   CMC_TEMP_DIR=$(mktemp -d)
#   CMC_MSG_FILE="$CMC_TEMP_DIR/COMMIT_EDITMSG"
#   trap 'rm -rf "$CMC_TEMP_DIR"' EXIT

# Usage:
#   test_conventional_merge_commit "name" "expected_first" "source" "input" ["expected_body"] [expected_exit]
#
# For first-line-only tests (CSV bulk): omit expected_body or pass ""
# For body preservation tests: pass expected_body string
test_conventional_merge_commit() {
	local test_name="$1"
	local expected_first_line="$2"
	local commit_source="$3"
	local input_msg="$4"
	local expected_body="${5:-}"
	local expected_exit="${6:-0}"

	# Write input (printf handles embedded newlines)
	printf '%s' "$input_msg" >"$CMC_MSG_FILE"

	# Run hook
	local actual_exit=0
	"$HOOK_MERGE" "$CMC_MSG_FILE" "$commit_source" >/dev/null 2>&1 || actual_exit=$?

	# Check first line
	local actual_first_line
	actual_first_line=$(head -n 1 "$CMC_MSG_FILE")

	local pass=true
	[ "$actual_first_line" != "$expected_first_line" ] && pass=false
	[ "$actual_exit" -ne "$expected_exit" ] && pass=false

	# Check body if provided
	local actual_blank_line=""
	local actual_body=""
	if [ -n "$expected_body" ]; then
		actual_blank_line=$(sed -n '2p' "$CMC_MSG_FILE")
		actual_body=$(sed -n '3p' "$CMC_MSG_FILE")
		[ -n "$actual_blank_line" ] && pass=false # Line 2 must be blank
		[ "$actual_body" != "$expected_body" ] && pass=false
	fi

	# Report result
	if [ "$pass" = true ]; then
		echo -e "${GREEN}✓${NC} $test_name"
		((PASSED++))
	else
		echo -e "${RED}✗${NC} $test_name"
		if [ "$actual_first_line" != "$expected_first_line" ]; then
			echo -e "  Expected first: ${YELLOW}$expected_first_line${NC}"
			echo -e "  Got first:      ${YELLOW}$actual_first_line${NC}"
		fi
		if [ "$actual_exit" -ne "$expected_exit" ]; then
			echo -e "  Expected exit: ${YELLOW}$expected_exit${NC}"
			echo -e "  Got exit:      ${YELLOW}$actual_exit${NC}"
		fi
		if [ -n "$expected_body" ]; then
			if [ -n "$actual_blank_line" ]; then
				echo -e "  Line 2 should be blank, got: ${YELLOW}$actual_blank_line${NC}"
			fi
			if [ "$actual_body" != "$expected_body" ]; then
				echo -e "  Expected body:  ${YELLOW}$expected_body${NC}"
				echo -e "  Got body:       ${YELLOW}$actual_body${NC}"
			fi
		fi
		((FAILED++))
	fi
}
