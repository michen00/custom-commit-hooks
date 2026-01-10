#!/usr/bin/env bash
# Test script for conventional-merge-commit hook

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared configurations
# shellcheck disable=SC1091 # Dynamic path via $TEST_SCRIPT_DIR
. "$TEST_SCRIPT_DIR/colors.sh"

HOOK="$TEST_SCRIPT_DIR/../scripts/conventional-merge-commit"
PASSED=0
FAILED=0

printf "Testing conventional-merge-commit hook...\n\n"

# Test helper function for conventional merge commit

test_message() {
	local test_name="$1"
	local expected_msg="$2"
	local commit_source="$3"
	local input_msg="$4"
	local expected_exit="${5:-0}"

	local temp_dir
	temp_dir=$(mktemp -d)
	trap 'rm -rf "$temp_dir"' RETURN

	local msg_file="$temp_dir/COMMIT_EDITMSG"
	echo "$input_msg" >"$msg_file"

	# Run hook with commit source and capture exit code
	local actual_exit=0
	"$HOOK" "$msg_file" "$commit_source" >/dev/null 2>&1 || actual_exit=$?

	# Check result
	local actual_msg
	actual_msg=$(head -n 1 "$msg_file")

	if [ "$actual_msg" = "$expected_msg" ] && [ "$actual_exit" -eq "$expected_exit" ]; then
		echo -e "${GREEN}✓${NC} $test_name"
		((PASSED++))
	else
		echo -e "${RED}✗${NC} $test_name"
		if [ "$actual_msg" != "$expected_msg" ]; then
			echo -e "  Expected msg: ${YELLOW}$expected_msg${NC}"
			echo -e "  Got msg:      ${YELLOW}$actual_msg${NC}"
		fi
		if [ "$actual_exit" -ne "$expected_exit" ]; then
			echo -e "  Expected exit: ${YELLOW}$expected_exit${NC}"
			echo -e "  Got exit:      ${YELLOW}$actual_exit${NC}"
		fi
		((FAILED++))
	fi
}

# === Basic merge conversions ===
test_message \
	"Merge commit converted to conventional format" \
	"chore: merge branch 'feat/example' into main" \
	"merge" \
	"Merge branch 'feat/example' into main"

test_message \
	"GitHub PR merge converted" \
	"chore: merge pull request #123 from user/feature-branch" \
	"merge" \
	"Merge pull request #123 from user/feature-branch"

# === Bare merge keywords ===
test_message \
	"Bare 'Merge' converted" \
	"chore: merge" \
	"merge" \
	"Merge"

test_message \
	"Bare 'merge' converted" \
	"chore: merge" \
	"merge" \
	"merge"

test_message \
	"Bare 'Merge ' converted" \
	"chore: merge " \
	"merge" \
	"Merge "

test_message \
	"Bare 'merge ' converted" \
	"chore: merge " \
	"merge" \
	"merge "

# === Messages that should NOT be modified ===
test_message \
	"'Merges' unchanged (not a merge keyword)" \
	"Merges ." \
	"merge" \
	"Merges ."

test_message \
	"'merges' unchanged (not a merge keyword)" \
	"merges ." \
	"merge" \
	"merges ."

test_message \
	"Non-merge commit source unchanged" \
	"Merge .+: ." \
	"commit" \
	"Merge .+"

test_message \
	"Empty commit source unchanged" \
	"Merge .+" \
	"" \
	"Merge .+"

test_message \
	"Message without [Mm]erge prefix unchanged" \
	".+" \
	"merge" \
	".+"

echo ""
echo -e "Results: ${GREEN}${PASSED} passed${NC}, ${RED}${FAILED} failed${NC}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
