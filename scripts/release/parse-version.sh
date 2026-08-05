#!/bin/sh
# Validate a release version and print it normalized as vMAJOR.MINOR.PATCH.
#
# Usage: parse-version.sh <version> [--require-v]
#
# With --require-v the leading "v" is mandatory; otherwise a bare X.Y.Z is
# accepted and normalized. Prints the tag on stdout, or exits 1 with a message
# on stderr. Exits 2 on bad arguments.
#
# Callers pass values that originate outside the repository (workflow inputs,
# pushed tag names, pull request branch names), so this rejects anything that is
# not strictly three dot-separated runs of digits.

set -eu

usage() {
	echo "Usage: $0 <version> [--require-v]" >&2
	exit 2
}

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
	usage
fi

version="$1"
require_v=0

if [ "$#" -eq 2 ]; then
	case "$2" in
	--require-v) require_v=1 ;;
	*) usage ;;
	esac
fi

if [ "$require_v" -eq 1 ]; then
	expected='vX.Y.Z'
else
	expected='X.Y.Z or vX.Y.Z'
fi

invalid() {
	echo "Error: invalid version '$version'. Expected $expected." >&2
	exit 1
}

rest="${version#v}"

# "${version#v}" is a no-op when there is no leading v, so comparing detects it.
if [ "$require_v" -eq 1 ] && [ "$rest" = "$version" ]; then
	invalid
fi

# Confirm both separators are present. "${x#*.}" is also a no-op when x has no
# dot, which would otherwise let "v1.2" parse as major/minor/minor.
major="${rest%%.*}"
after_major="${rest#*.}"
[ "$after_major" != "$rest" ] || invalid

minor="${after_major%%.*}"
patch="${after_major#*.}"
[ "$patch" != "$after_major" ] || invalid

# A glob such as v[0-9]*.[0-9]*.[0-9]* would also accept "v1.0.0; rm -rf /",
# because * matches separators and metacharacters too. Check each component.
for part in "$major" "$minor" "$patch"; do
	case "$part" in
	'' | *[!0-9]*) invalid ;;
	esac
done

echo "v$major.$minor.$patch"
