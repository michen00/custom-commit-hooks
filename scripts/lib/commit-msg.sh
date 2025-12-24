#!/bin/sh
# Shared library for commit message hooks
# Source this file: . "$(dirname "$0")/lib/commit-msg.sh"

# Newline character for POSIX string operations
# shellcheck disable=SC2034  # NL is used by scripts that source this file
NL='
'

# Check if a file ends with a newline
# Usage: check_trailing_newline "$file"
# Sets: file_ends_with_nl (0 or 1)
check_trailing_newline() {
	file_ends_with_nl=0
	if [ -s "$1" ]; then
		# Command substitution strips trailing newlines
		# So if last_char is empty, file ends with newline
		last_char=$(tail -c 1 "$1")
		[ -z "$last_char" ] && file_ends_with_nl=1
	fi
}

# Read commit message file and split into first line and rest
# Usage: read_commit_msg "$file"
# Sets: COMMIT_FIRST_LINE, COMMIT_REST, file_ends_with_nl
read_commit_msg() {
	check_trailing_newline "$1"
	COMMIT_CONTENT=$(cat "$1")
	COMMIT_FIRST_LINE="${COMMIT_CONTENT%%"${NL}"*}"
	COMMIT_REST="${COMMIT_CONTENT#*"${NL}"}"
	# If no newline, rest equals content (no body)
	[ "$COMMIT_REST" = "$COMMIT_CONTENT" ] && COMMIT_REST=""
}

# Write commit message with proper newline handling
# Usage: write_commit_msg "$file" "$new_first_line" "$rest"
# Uses: file_ends_with_nl, NL (must be set before calling)
write_commit_msg() {
	_wcm_file="$1"
	_wcm_first_line="$2"
	_wcm_rest="$3"

	if [ -n "$_wcm_rest" ]; then
		# Strip trailing newline to avoid double newline when we add it back
		_wcm_rest_stripped="$_wcm_rest"
		case "$_wcm_rest_stripped" in
		*"${NL}")
			_wcm_rest_stripped="${_wcm_rest_stripped%"${NL}"}"
			;;
		esac
		# printf adds \n after first line, rest starts with \n (blank line separator)
		# Result: first_line\n\nbody (two newlines = blank line between)
		if [ "$file_ends_with_nl" -eq 1 ]; then
			printf '%s\n%s\n' "$_wcm_first_line" "$_wcm_rest_stripped" >"$_wcm_file"
		else
			printf '%s\n%s' "$_wcm_first_line" "$_wcm_rest_stripped" >"$_wcm_file"
		fi
	else
		if [ "$file_ends_with_nl" -eq 1 ]; then
			printf '%s\n' "$_wcm_first_line" >"$_wcm_file"
		else
			printf '%s' "$_wcm_first_line" >"$_wcm_file"
		fi
	fi
}
