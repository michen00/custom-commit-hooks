#!/usr/bin/env bash
# Test script for conventional-merge-commit hook

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOK="$REPO_ROOT/scripts/conventional-merge-commit"

# Load shared color definitions
# shellcheck disable=SC1091 # Dynamic path via $SCRIPT_DIR
. "$SCRIPT_DIR/colors.sh"

PASSED=0
FAILED=0

# Test helper function
test_message() {
	local test_name="$1"
	local expected_msg="$2"
	local commit_source="$3"
	local input_msg="$4"

	local temp_dir
	temp_dir=$(mktemp -d)
	trap 'rm -rf "$temp_dir"' RETURN

	local msg_file="$temp_dir/COMMIT_EDITMSG"
	echo "$input_msg" >"$msg_file"

	# Run hook with commit source
	"$HOOK" "$msg_file" "$commit_source" >/dev/null 2>&1 || true

	# Check result
	local actual_msg
	actual_msg=$(head -n 1 "$msg_file")

	if [ "$actual_msg" = "$expected_msg" ]; then
		echo -e "${GREEN}✓${NC} $test_name"
		((PASSED++))
	else
		echo -e "${RED}✗${NC} $test_name"
		echo -e "  Expected: ${YELLOW}$expected_msg${NC}"
		echo -e "  Got:      ${YELLOW}$actual_msg${NC}"
		((FAILED++))
	fi
}

echo "Testing conventional-merge-commit hook..."
echo ""

# Test 1: Merge commit -> should convert to conventional format
test_message \
	"Merge commit converted to conventional format" \
	"chore: merge branch 'feature/new-api' into main" \
	"merge" \
	"Merge branch 'feature/new-api' into main"

# Test 2: Merge commit with body -> should preserve body
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT
msg_file="$temp_dir/COMMIT_EDITMSG"
printf "Merge branch 'feature/new-api' into main\n\nMerge details\n" >"$msg_file"
"$HOOK" "$msg_file" "merge" >/dev/null 2>&1 || true
if [ "$(head -n 1 "$msg_file")" = "chore: merge branch 'feature/new-api' into main" ] && [ "$(tail -n +3 "$msg_file" | head -n 1)" = "Merge details" ]; then
	echo -e "${GREEN}✓${NC} Merge commit body preserved"
	((PASSED++))
else
	echo -e "${RED}✗${NC} Merge commit body not preserved"
	((FAILED++))
fi

# Test 3: Non-merge commit source -> should not modify
test_message \
	"Non-merge commit source unchanged" \
	"feat: add new feature" \
	"commit" \
	"feat: add new feature"

# Test 4: Empty commit source -> should not modify
test_message \
	"Empty commit source unchanged" \
	"feat: add new feature" \
	"" \
	"feat: add new feature"

# Test 5: Non-merge message format -> should not modify
test_message \
	"Non-merge message format unchanged" \
	"feat: add new feature" \
	"merge" \
	"feat: add new feature"

# Test 6: Merge message without 'Merge ' prefix -> should not modify
test_message \
	"Message without Merge prefix unchanged" \
	"chore: merge something" \
	"merge" \
	"chore: merge something"

# Test 7: Various merge message formats
test_message \
	"Merge remote-tracking branch converted" \
	"chore: merge remote-tracking branch 'origin/feature' into main" \
	"merge" \
	"Merge remote-tracking branch 'origin/feature' into main"

test_message \
	"Merge commit with hash converted" \
	"chore: merge commit abc123def456" \
	"merge" \
	"Merge commit abc123def456"

echo ""
echo -e "Results: ${GREEN}${PASSED} passed${NC}, ${RED}${FAILED} failed${NC}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
