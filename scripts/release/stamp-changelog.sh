#!/bin/sh

# Regenerate the changelog with the release under preparation stamped as its own
# section.
#
# Usage: stamp-changelog.sh <vX.Y.Z> [changelog_file]
#
# This exists because refreshing the Unreleased section is the wrong operation
# during a release. `git cliff --unreleased` reports commits since the newest
# tag, so once that tag is created every commit it covers stops being unreleased
# — and if no section was ever written for it, the next refresh drops those
# entries with nowhere to put them. That is what happened to v0.1.0: it shipped,
# no `## [0.1.0]` section was ever added, and the following release PR deleted
# 134 lines of history that had only ever lived under Unreleased.
#
# Passing --tag makes git-cliff treat the pending version as released, so the
# whole file is rebuilt with a section per tag and the pending one at the top.
# Regenerating everything rather than splicing is safe here because the released
# sections are derived from tags and commits, both immutable; the only observed
# differences against a hand-formatted file are whitespace that prettier
# normalizes on the very next step of the workflow.

set -eu

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
	echo "Usage: $0 <vX.Y.Z> [changelog_file]" >&2
	exit 1
fi

# The release workflows validate the tag before they get here, but this script
# is also run by hand, and everything below treats the version as trusted: it
# reaches git-cliff as a tag and the guard below as a grep pattern. Normalize it
# through the same strict parser the workflows use so a standalone run cannot
# smuggle anything but three dot-separated runs of digits past this point.
script_dir="$(dirname "$0")"
if ! tag="$("$script_dir/parse-version.sh" "$1")"; then
	exit 1
fi

changelog_file="${2:-CHANGELOG.md}"

if [ ! -f "$changelog_file" ]; then
	echo "Error: changelog file not found: $changelog_file" >&2
	exit 1
fi

if ! command -v git-cliff >/dev/null 2>&1; then
	echo "Error: git-cliff is required to update $changelog_file" >&2
	exit 1
fi

tmp_changelog="$(mktemp)"
trap 'rm -f "$tmp_changelog"' EXIT INT TERM HUP

# Build into scratch space first. `--output` truncates before it writes, so
# pointing it at the changelog would leave a half-written file behind on any
# git-cliff failure — which matters for local runs, where the tree is not
# disposable.
git cliff --tag "$tag" --output "$tmp_changelog"

if [ ! -s "$tmp_changelog" ]; then
	echo "Error: git-cliff produced an empty changelog for $tag" >&2
	exit 1
fi

# A regeneration that lost the section for the version being released, or one
# that came back shorter than what it replaces, means git-cliff disagreed with
# the tag history rather than that there was nothing to say. Refuse it: the
# whole point of this script is that a silent shrink already cost this
# repository its v0.1.0 entries once.
version="${tag#v}"
# Dots are wildcards to grep, so a bare ${version} would also accept a
# `## [1x2x3]` header. Validation above leaves dots as the only metacharacter
# that can still reach this pattern.
version_pattern="$(printf '%s' "$version" | sed 's/\./\\./g')"
if ! grep -q "^## \[${version_pattern}\]" "$tmp_changelog"; then
	echo "Error: no '## [${version}]' section in the regenerated changelog." >&2
	exit 1
fi

old_sections="$(grep -c '^## \[' "$changelog_file" || true)"
new_sections="$(grep -c '^## \[' "$tmp_changelog" || true)"
if [ "$new_sections" -lt "$old_sections" ]; then
	echo "Error: regeneration dropped sections ($old_sections -> $new_sections)." >&2
	exit 1
fi

# git-cliff succeeded and the result passed inspection, so publish it. Writing
# through the existing file rather than renaming over it keeps the changelog's
# permissions and inode.
cat "$tmp_changelog" >"$changelog_file"

echo "Stamped $tag into $changelog_file"
