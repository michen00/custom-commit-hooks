#!/usr/bin/env bash
# Test helper for checking enhance-scope commit message content

HOOK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../scripts/enhance-scope"

# Usage:
#   test_enhance_scope "name" "expected_first" "setup_cmd" "input_msg" ["expected_body"]
#
# For first-line-only tests: omit expected_body
# For body preservation tests: pass expected_body (full body from line 3 onward)
test_enhance_scope() {
	local test_name="$1"
	local expected_msg="$2"
	local setup_cmd="$3"
	local input_msg="$4"
	local expected_body="${5:-}"

	local temp_dir
	temp_dir=$(mktemp -d)
	trap 'rm -rf "$temp_dir"' RETURN

	# Run test in subshell and write results to temp files
	local actual_msg=""
	local actual_blank_line=""
	local actual_body=""

	(
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
		printf '%s' "$input_msg" >"$msg_file" || exit 1

		# Run hook (must be in git repo directory for git commands to work)
		"$HOOK" "$msg_file" >/dev/null 2>&1 || true

		# Write results to temp files for parent to read
		head -n 1 "$msg_file" >"$temp_dir/result_first"
		sed -n '2p' "$msg_file" >"$temp_dir/result_blank"
		# Capture full body (line 3 to end)
		tail -n +3 "$msg_file" >"$temp_dir/result_body"
	)

	# Read results from temp files
	actual_msg=$(cat "$temp_dir/result_first" 2>/dev/null) || actual_msg=""
	actual_blank_line=$(cat "$temp_dir/result_blank" 2>/dev/null) || actual_blank_line=""
	actual_body=$(cat "$temp_dir/result_body" 2>/dev/null) || actual_body=""

	local pass=true
	[ "$actual_msg" != "$expected_msg" ] && pass=false

	# Check body if provided
	if [ -n "$expected_body" ]; then
		[ -n "$actual_blank_line" ] && pass=false # Line 2 must be blank
		[ "$actual_body" != "$expected_body" ] && pass=false
	fi

	if [ "$pass" = true ]; then
		echo -e "${GREEN}✓${NC} $test_name"
		((PASSED++))
	else
		echo -e "${RED}✗${NC} $test_name"
		if [ "$actual_msg" != "$expected_msg" ]; then
			echo -e "  Expected first: ${YELLOW}$expected_msg${NC}"
			echo -e "  Got first:      ${YELLOW}$actual_msg${NC}"
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
