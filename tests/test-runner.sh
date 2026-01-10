#!/usr/bin/env bash
# Test runner for all commit hook tests

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared configurations
# shellcheck disable=SC1091 # Dynamic path via $TEST_SCRIPT_DIR
. "$TEST_SCRIPT_DIR/colors.sh"

TOTAL_PASSED=0
TOTAL_FAILED=0

# Run a test script
run_test() {
	local test_script="$1"
	local test_name="$2"

	echo -e "${CYAN}Running $test_name...${NC}"
	echo ""

	if bash "$test_script"; then
		((TOTAL_PASSED++))
		echo ""
		return 0
	else
		((TOTAL_FAILED++))
		echo ""
		return 1
	fi
}

echo "=========================================="
echo "  Commit Hooks Test Suite"
echo "=========================================="
echo ""

# Run all tests
run_test "$TEST_SCRIPT_DIR/test-examples.sh" "basic usage tests"
run_test "$TEST_SCRIPT_DIR/test-lib-commit-msg.sh" "lib/commit-msg.sh tests"
run_test "$TEST_SCRIPT_DIR/test-enhance-scope.sh" "enhance-scope tests"
run_test "$TEST_SCRIPT_DIR/test-conventional-merge-commit.sh" "conventional-merge-commit tests"

# Summary
echo "=========================================="
echo "  Test Summary"
echo "=========================================="
echo -e "Total test suites: ${GREEN}$TOTAL_PASSED passed${NC}, ${RED}$TOTAL_FAILED failed${NC}"
echo ""

if [ $TOTAL_FAILED -eq 0 ]; then
	echo -e "${GREEN}All tests passed!${NC}"
	exit 0
else
	echo -e "${RED}Some tests failed!${NC}"
	exit 1
fi
