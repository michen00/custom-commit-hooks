#!/usr/bin/env bash
# Test script for basic usage

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configurations and helpers
# shellcheck disable=SC1091 # Dynamic path via $TEST_SCRIPT_DIR
. "$TEST_SCRIPT_DIR/colors.sh"
# shellcheck disable=SC1091
. "$TEST_SCRIPT_DIR/enhance-scope-helper.sh"
# shellcheck disable=SC1091
. "$TEST_SCRIPT_DIR/conventional-merge-commit-helper.sh"

PASSED=0
FAILED=0

# Set up shared temp directory for conventional-merge-commit tests
CMC_TEMP_DIR=$(mktemp -d)
# shellcheck disable=SC2034 # CMC_MSG_FILE is used by sourced helper
CMC_MSG_FILE="$CMC_TEMP_DIR/COMMIT_EDITMSG"
trap 'rm -rf "$CMC_TEMP_DIR"' EXIT

printf "Testing basic usage of enhance-scope and conventional-merge-commit hooks...\n\n"

# === Tests ===

test_conventional_merge_commit \
	"Merge commit body preserved" \
	"chore: merge branch 'feature' into main" \
	"merge" \
	"Merge branch 'feature' into main

Detailed merge description here
" \
	"Detailed merge description here"

test_enhance_scope \
	"Commit body preserved after scope addition" \
	"feat(test.txt): add feature" \
	"echo 'content' > test.txt" \
	"feat: add feature

This is the body
with multiple lines" \
	"This is the body
with multiple lines"

echo ""
echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
