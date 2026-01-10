#!/usr/bin/env bash
# Test helper for checking enhance-scope commit message content

HOOK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../scripts/enhance-scope"

test_enhance_scope() {
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

		# Setup files (POSIX-compatible commands only)
		sh -c "$setup_cmd" || exit 1

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
