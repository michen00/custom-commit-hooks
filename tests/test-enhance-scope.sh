#!/usr/bin/env bash
# Test script for enhance-scope hook

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOK="$REPO_ROOT/scripts/enhance-scope"

# Load shared color definitions
# shellcheck disable=SC1091 # Dynamic path via $SCRIPT_DIR
. "$SCRIPT_DIR/colors.sh"

PASSED=0
FAILED=0

# Test helper for checking commit message content
test_message() {
	local test_name="$1"
	local expected_msg="$2"
	local setup_cmd="$3"
	local input_msg="$4"

	local temp_dir
	temp_dir=$(mktemp -d)
	trap 'rm -rf "$temp_dir"' RETURN

	# Run test and capture result
	local actual_msg=""
	actual_msg=$(
		cd "$temp_dir" || exit 1
		git init -q || exit 1
		git config user.name "Test User" || exit 1
		git config user.email "test@example.com" || exit 1

		# Setup files first (setup_cmd must be trusted - all test inputs are hardcoded)
		bash -c "$setup_cmd" || exit 1

		# Stage files (before creating commit message file to avoid staging it)
		git add -A || true

		# Create commit message file
		local msg_file="COMMIT_EDITMSG"
		echo "$input_msg" >"$msg_file" || exit 1

		# Run hook (must be in git repo directory for git commands to work)
		"$HOOK" "$msg_file" >/dev/null 2>&1 || true

		# Output result for parent to capture
		head -n 1 "$msg_file" || echo ""
	) || actual_msg=""

	if [ "${actual_msg:-}" = "$expected_msg" ]; then
		echo -e "${GREEN}✓${NC} $test_name"
		((PASSED++))
	else
		echo -e "${RED}✗${NC} $test_name"
		echo -e "  Expected: ${YELLOW}$expected_msg${NC}"
		echo -e "  Got:      ${YELLOW}$actual_msg${NC}"
		((FAILED++))
	fi
}

echo "Testing enhance-scope hook..."
echo ""

# Test 1: Single file, conventional commit without scope -> should add scope
test_message \
	"Single file commit adds scope" \
	"feat(test.txt): add feature" \
	"echo 'content' > test.txt" \
	"feat: add feature"

# Test 2: Single file, already has scope -> should not modify
test_message \
	"Single file with existing scope unchanged" \
	"feat(existing): add feature" \
	"echo 'content' > test.txt" \
	"feat(existing): add feature"

# Test 3: Single file, filename already in message -> should not modify
test_message \
	"Single file with filename in message unchanged" \
	"feat: update test.txt" \
	"echo 'content' > test.txt" \
	"feat: update test.txt"

# Test 4: Multiple files -> should not modify
test_message \
	"Multiple files unchanged" \
	"feat: add features" \
	"echo 'content1' > file1.txt; echo 'content2' > file2.txt" \
	"feat: add features"

# Test 5: No files staged -> should not modify
test_message \
	"No files unchanged" \
	"feat: add feature" \
	"true" \
	"feat: add feature"

# Test 6: Non-conventional commit -> should not modify
test_message \
	"Non-conventional commit unchanged" \
	"Add new feature" \
	"echo 'content' > test.txt" \
	"Add new feature"

# Test 7: Summary too long after adding scope -> should not modify
test_message \
	"Long summary unchanged when adding scope exceeds limit" \
	"feat: this is a very long commit message that exceeds" \
	"echo 'content' > test.txt" \
	"feat: this is a very long commit message that exceeds"

# Test 8: Different commit types
for type in build chore ci docs feat fix perf refactor revert style test; do
	test_message \
		"$type commit type adds scope" \
		"$type(test.txt): message" \
		"echo 'content' > test.txt" \
		"$type: message"
done

# Test 9: Commit with body preserved
test_message \
	"Commit body preserved after scope addition" \
	"feat(test.txt): add feature" \
	"echo 'content' > test.txt" \
	"feat: add feature

This is the body
with multiple lines"

# Verify body is preserved
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

# Run test in subshell to isolate directory changes
if (
	cd "$temp_dir" || exit 1
	git init -q || exit 1
	git config user.name "Test User" || exit 1
	git config user.email "test@example.com" || exit 1
	echo 'content' >test.txt || exit 1
	git add test.txt || exit 1
	msg_file="$temp_dir/COMMIT_EDITMSG"
	printf "feat: add feature\n\nThis is the body\nwith multiple lines\n" >"$msg_file" || exit 1
	"$HOOK" "$msg_file" >/dev/null 2>&1 || true
	[ "$(head -n 1 "$msg_file")" = "feat(test.txt): add feature" ] && [ "$(tail -n +3 "$msg_file" | head -n 1)" = "This is the body" ]
); then
	echo -e "${GREEN}✓${NC} Commit body preserved correctly"
	((PASSED++))
else
	echo -e "${RED}✗${NC} Commit body not preserved correctly"
	((FAILED++))
fi

echo ""
echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
