#!/usr/bin/env bash
# Integration test: verify hooks work with pre-commit framework
# This test creates a real git repo and tests actual merge commits.

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared configurations
# shellcheck disable=SC1091
. "$TEST_SCRIPT_DIR/colors.sh"

PASSED=0
FAILED=0

# Cleanup function
cleanup() {
	if [ -n "${TEST_REPO:-}" ] && [ -d "$TEST_REPO" ]; then
		rm -rf "$TEST_REPO"
	fi
}
trap cleanup EXIT

# Create a temporary git repository with pre-commit configured
setup_test_repo() {
	TEST_REPO=$(mktemp -d)
	cd "$TEST_REPO" || exit 1

	git init --quiet -b main
	git config user.name "Test User"
	git config user.email "test@example.com"

	# Create pre-commit config pointing to local hooks
	cat >.pre-commit-config.yaml <<EOF
repos:
  - repo: local
    hooks:
      - id: conventional-merge-commit
        name: conventional-merge-commit
        entry: $(cd "$TEST_SCRIPT_DIR/.." && pwd)/scripts/conventional-merge-commit
        language: script
        stages: [prepare-commit-msg]
EOF

	# Install pre-commit hooks
	pre-commit install --hook-type prepare-commit-msg >/dev/null 2>&1

	# Initial commit on main
	echo "initial" >file.txt
	git add file.txt
	git commit --quiet -m "feat: initial commit"
}

# Test helper
test_result() {
	local test_name="$1"
	local expected="$2"
	local actual="$3"

	if [ "$actual" = "$expected" ]; then
		echo -e "${GREEN}✓${NC} $test_name"
		((PASSED++))
	else
		echo -e "${RED}✗${NC} $test_name"
		echo -e "  Expected: ${YELLOW}$expected${NC}"
		echo -e "  Got:      ${YELLOW}$actual${NC}"
		((FAILED++))
	fi
}

echo "Testing pre-commit integration..."
echo ""

# Check if pre-commit is available
if ! command -v pre-commit >/dev/null 2>&1; then
	echo -e "${YELLOW}⚠${NC} pre-commit not installed, skipping integration tests"
	exit 0
fi

# === Test 1: Merge commit transformation ===
setup_test_repo

# Create feature branch with a commit
git checkout --quiet -b feature/test
echo "feature" >feature.txt
git add feature.txt
git commit --quiet -m "feat: add feature"

# Merge back to main (non-fast-forward to force merge commit)
git checkout --quiet main
git merge --quiet --no-ff --no-edit feature/test

# Get the merge commit message
merge_msg=$(git log -1 --format=%s)

test_result \
	"Merge commit transformed via pre-commit" \
	"chore: merge branch 'feature/test'" \
	"$merge_msg"

# === Test 2: Regular commit unchanged ===
cleanup
setup_test_repo

echo "regular change" >regular.txt
git add regular.txt
git commit --quiet -m "feat: regular commit"

regular_msg=$(git log -1 --format=%s)

test_result \
	"Regular commit unchanged via pre-commit" \
	"feat: regular commit" \
	"$regular_msg"

# === Test 3: Commit with existing chore prefix unchanged ===
cleanup
setup_test_repo

git checkout --quiet -b feature/chore-test
echo "chore feature" >chore.txt
git add chore.txt
git commit --quiet -m "chore: add chore file"

git checkout --quiet main
# Use a custom merge message that already has conventional format
git merge --quiet --no-ff -m "chore: merge feature/chore-test" feature/chore-test

chore_msg=$(git log -1 --format=%s)

test_result \
	"Merge with existing chore prefix unchanged" \
	"chore: merge feature/chore-test" \
	"$chore_msg"

echo ""
echo -e "Results: ${GREEN}${PASSED} passed${NC}, ${RED}${FAILED} failed${NC}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
