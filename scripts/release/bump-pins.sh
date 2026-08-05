#!/bin/sh
# Point this repository's own pre-commit `rev:` pins at a release tag.
#
# Usage: bump-pins.sh <vX.Y.Z> [file...]
#
# Defaults to README.md alone. Only a `rev:` that directly follows a `repo:` line
# for this repository is rewritten, which matters because .pre-commit-config.yaml
# pins many third-party repositories the same way and a plain search-and-replace
# on the old version would corrupt them.
#
# .pre-commit-config.yaml is deliberately NOT bumped during a release. pre-commit
# resolves a `rev:` by checking that ref out, and the release tag does not exist
# until after the release PR merges, so pinning the pending version deadlocks the
# release PR's own checks:
#
#     error: pathspec 'v0.1.0' did not match any file(s) known to git
#
# The weekly pre-commit-autoupdate workflow moves that self-pin forward on its own
# once the tag exists. Pass the file explicitly if you need to bump it by hand
# after a release.
#
# Exits 2 on bad arguments and 3 when a named file contains no pin for this
# repository, so a release workflow fails loudly instead of shipping a stale pin.

set -eu

REPO_SLUG='michen00/custom-commit-hooks'

usage() {
	echo "Usage: $0 <vX.Y.Z> [file...]" >&2
	exit 2
}

if [ "$#" -lt 1 ]; then
	usage
fi

tag="$1"
shift

# Reuse the release parser so an invalid tag cannot reach the files.
parse_version="$(dirname "$0")/parse-version.sh"
if [ ! -x "$parse_version" ]; then
	echo "Error: $parse_version is missing or not executable" >&2
	exit 2
fi

if ! tag="$("$parse_version" "$tag" --require-v)"; then
	usage
fi

if [ "$#" -eq 0 ]; then
	set -- README.md
fi

status=0

for file in "$@"; do
	if [ ! -f "$file" ]; then
		echo "Error: file not found: $file" >&2
		exit 2
	fi

	tmp="$(mktemp)"

	# Rewriting only the `rev:` token leaves indentation and any trailing comment
	# (README carries "# Use the latest version") exactly as they were.
	if awk -v tag="$tag" -v slug="$REPO_SLUG" '
	BEGIN { armed = 0; changed = 0 }
	index($0, "repo:") && index($0, slug) {
		armed = 1
		print
		next
	}
	armed && $0 ~ /^[[:space:]]*rev:/ {
		sub(/rev:[[:space:]]*[^[:space:]]+/, "rev: " tag)
		armed = 0
		changed++
		print
		next
	}
	{ print }
	END { exit (changed > 0 ? 0 : 3) }
	' "$file" >"$tmp"; then
		if cmp -s "$tmp" "$file"; then
			echo "Already at $tag: $file"
		else
			cat "$tmp" >"$file"
			echo "Bumped to $tag: $file"
		fi
	else
		echo "Error: no $REPO_SLUG pin found in $file" >&2
		status=3
	fi

	rm -f "$tmp"
done

exit "$status"
