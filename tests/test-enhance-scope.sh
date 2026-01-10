#!/usr/bin/env bash
# Test script for enhance-scope hook

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared configurations
# Dynamic path via $TEST_SCRIPT_DIR
# shellcheck disable=SC1091
. "$TEST_SCRIPT_DIR/colors.sh"
# shellcheck disable=SC1091
. "$TEST_SCRIPT_DIR/enhance-scope-helper.sh"

PASSED=0
FAILED=0

printf "Testing enhance-scope hook...\n\n"

# Test 1: Single file, conventional commit without scope -> should add scope
test_enhance_scope \
	"Single file commit adds scope" \
	"feat(test.txt): add feature" \
	"echo 'content' > test.txt" \
	"feat: add feature"

# Test 2: Single file, already has scope -> should not modify
test_enhance_scope \
	"Single file with existing scope unchanged" \
	"feat(existing): add feature" \
	"echo 'content' > test.txt" \
	"feat(existing): add feature"

# Test 3: Single file, filename already in message -> should not modify
test_enhance_scope \
	"Single file with filename in message unchanged" \
	"feat: update test.txt" \
	"echo 'content' > test.txt" \
	"feat: update test.txt"

# Test 4: Multiple files -> should not modify
test_enhance_scope \
	"Multiple files unchanged" \
	"feat: add features" \
	"echo 'content1' > file1.txt; echo 'content2' > file2.txt" \
	"feat: add features"

# Test 5: No files staged -> should not modify
test_enhance_scope \
	"No files unchanged" \
	"feat: add feature" \
	"true" \
	"feat: add feature"

# Test 6: Non-conventional commit -> should not modify
test_enhance_scope \
	"Non-conventional commit unchanged" \
	"Add new feature" \
	"echo 'content' > test.txt" \
	"Add new feature"

# Test 7: Summary too long after adding scope -> should not modify
test_enhance_scope \
	"Long summary unchanged when adding scope exceeds limit" \
	"feat: this is a very long commit message that exceeds" \
	"echo 'content' > test.txt" \
	"feat: this is a very long commit message that exceeds"

# Test 8: Different commit types
for type in build chore ci docs feat fix perf refactor revert style test; do
	test_enhance_scope \
		"$type commit type adds scope" \
		"$type(test.txt): message" \
		"echo 'content' > test.txt" \
		"$type: message"
done

echo ""
echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
