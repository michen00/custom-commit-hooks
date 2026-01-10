#!/usr/bin/env bash
# Test script for scripts/lib/commit-msg.sh shared library
# shellcheck disable=SC2154 # Variables from sourced library: file_ends_with_nl, NL, COMMIT_FIRST_LINE, COMMIT_REST

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared configurations
# shellcheck disable=SC1091 # Dynamic path via $TEST_SCRIPT_DIR
. "$TEST_SCRIPT_DIR/colors.sh"

# Load the library under test (provides: NL, file_ends_with_nl, COMMIT_FIRST_LINE, COMMIT_REST)
# shellcheck disable=SC1091
. "$TEST_SCRIPT_DIR/../scripts/lib/commit-msg.sh"

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

printf "Testing scripts/lib/commit-msg.sh...\n\n"

# Test: NL variable is a newline
if [ "$NL" = "
" ]; then
	pass "NL variable is a newline character"
else
	fail "NL variable is not a newline" "Got: $(printf '%s' "$NL" | od -c)"
fi

# Test: check_trailing_newline with file ending in newline
temp_file=$(mktemp)
printf "line1\nline2\n" >"$temp_file"
check_trailing_newline "$temp_file"
if [ "$file_ends_with_nl" -eq 1 ]; then
	pass "check_trailing_newline detects trailing newline"
else
	fail "check_trailing_newline should return 1 for file with trailing newline"
fi
rm -f "$temp_file"

# Test: check_trailing_newline with file NOT ending in newline
temp_file=$(mktemp)
printf "line1\nline2" >"$temp_file"
check_trailing_newline "$temp_file"
if [ "$file_ends_with_nl" -eq 0 ]; then
	pass "check_trailing_newline detects no trailing newline"
else
	fail "check_trailing_newline should return 0 for file without trailing newline"
fi
rm -f "$temp_file"

# Test: check_trailing_newline with empty file
temp_file=$(mktemp)
: >"$temp_file"
check_trailing_newline "$temp_file"
if [ "$file_ends_with_nl" -eq 0 ]; then
	pass "check_trailing_newline handles empty file"
else
	fail "check_trailing_newline should return 0 for empty file"
fi
rm -f "$temp_file"

# Test: read_commit_msg splits first line and rest
temp_file=$(mktemp)
printf "first line\n\nbody line 1\nbody line 2\n" >"$temp_file"
read_commit_msg "$temp_file"
if [ "$COMMIT_FIRST_LINE" = "first line" ]; then
	pass "read_commit_msg extracts first line"
else
	fail "read_commit_msg first line extraction" "Expected: 'first line'" "Got: '$COMMIT_FIRST_LINE'"
fi
# COMMIT_REST should start with \n (the blank line)
if [ "${COMMIT_REST#?}" = "body line 1
body line 2" ]; then
	pass "read_commit_msg extracts rest (body with blank line)"
else
	fail "read_commit_msg rest extraction" "Got: '$COMMIT_REST'"
fi
rm -f "$temp_file"

# Test: read_commit_msg with no body
temp_file=$(mktemp)
printf "just a summary\n" >"$temp_file"
read_commit_msg "$temp_file"
if [ "$COMMIT_FIRST_LINE" = "just a summary" ] && [ -z "$COMMIT_REST" ]; then
	pass "read_commit_msg handles message with no body"
else
	fail "read_commit_msg no body" "FIRST_LINE: '$COMMIT_FIRST_LINE'" "REST: '$COMMIT_REST'"
fi
rm -f "$temp_file"

# Test: write_commit_msg with body, preserving trailing newline
temp_file=$(mktemp)
printf "original\n\nbody\n" >"$temp_file"
read_commit_msg "$temp_file"
write_commit_msg "$temp_file" "new first line" "$COMMIT_REST"
# Check content (without worrying about exact trailing newline for now)
if [ "$(head -n 1 "$temp_file")" = "new first line" ] && [ "$(sed -n '3p' "$temp_file")" = "body" ]; then
	pass "write_commit_msg writes new first line with body"
else
	fail "write_commit_msg with body" "Got: '$(cat "$temp_file")'"
fi
# Check trailing newline preserved
last_byte=$(tail -c 1 "$temp_file" | od -An -tx1 | tr -d ' \n')
if [ "$last_byte" = "0a" ]; then
	pass "write_commit_msg preserves trailing newline"
else
	fail "write_commit_msg should preserve trailing newline" "Last byte: $last_byte"
fi
rm -f "$temp_file"

# Test: write_commit_msg without body (preserves trailing newline)
temp_file=$(mktemp)
printf "original\n" >"$temp_file"
read_commit_msg "$temp_file"
write_commit_msg "$temp_file" "new summary" ""
# Check content and trailing newline separately (cat strips trailing newlines)
content=$(cat "$temp_file")
last_byte=$(tail -c 1 "$temp_file" | od -An -tx1 | tr -d ' \n')
if [ "$content" = "new summary" ] && [ "$last_byte" = "0a" ]; then
	pass "write_commit_msg writes summary only (with trailing newline)"
else
	fail "write_commit_msg summary only" "Content: '$content'" "Last byte: '$last_byte'"
fi
rm -f "$temp_file"

# Test: write_commit_msg preserves NO trailing newline when original had none
temp_file=$(mktemp)
printf "original" >"$temp_file"
read_commit_msg "$temp_file"
write_commit_msg "$temp_file" "new summary" ""
last_byte=$(tail -c 1 "$temp_file" | od -An -tx1 | tr -d ' \n')
if [ "$last_byte" != "0a" ]; then
	pass "write_commit_msg preserves no trailing newline when original had none"
else
	fail "write_commit_msg should not add trailing newline" "Last byte: $last_byte"
fi
rm -f "$temp_file"

echo ""
echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
