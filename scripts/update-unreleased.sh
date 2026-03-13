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

git cliff --unreleased --prepend "$changelog_file"
echo "Updated unreleased changelog entries in $changelog_file"
