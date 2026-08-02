#!/bin/sh

set -eu

if [ "$#" -gt 1 ]; then
	echo "Usage: $0 [changelog_file]" >&2
	exit 1
fi

changelog_file="${1:-CHANGELOG.md}"

if [ ! -f "$changelog_file" ]; then
	echo "Error: changelog file not found: $changelog_file" >&2
	exit 1
fi

if ! command -v git-cliff >/dev/null 2>&1; then
	echo "Error: git-cliff is required to update $changelog_file" >&2
	exit 1
fi

tmp_sections="$(mktemp)"
trap 'rm -f "$tmp_sections"' EXIT INT TERM HUP

# Keep only released sections (and footer), dropping any stale unreleased block.
awk '
BEGIN {
	in_sections = 0
	skip_unreleased = 0
}
/^## \[/ {
	in_sections = 1
	if ($0 ~ /^## \[Unreleased\]/) {
		skip_unreleased = 1
		next
	}
	skip_unreleased = 0
}
in_sections && !skip_unreleased {
	print
}
' "$changelog_file" >"$tmp_sections"

mv "$tmp_sections" "$changelog_file"
# Prepend header + unreleased content, but keep a single footer at the end.
git cliff --unreleased --strip footer --prepend "$changelog_file"
echo "Updated unreleased changelog entries in $changelog_file"
