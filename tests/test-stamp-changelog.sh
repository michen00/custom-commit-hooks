#!/usr/bin/env bash
# Test script for scripts/release/stamp-changelog.sh

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared configurations
# shellcheck disable=SC1091 # Dynamic path via $TEST_SCRIPT_DIR
. "$TEST_SCRIPT_DIR/colors.sh"

STAMP="$TEST_SCRIPT_DIR/../scripts/release/stamp-changelog.sh"

PASSED=0
FAILED=0

pass() {
	echo -e "${GREEN}✓${NC} $1"
	((PASSED++))
}

fail() {
	echo -e "${RED}✗${NC} $1"
	shift
	for msg in "$@"; do
		echo -e "  ${YELLOW}$msg${NC}"
	done
	((FAILED++))
}

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# A changelog with one released section, standing in for the real file. The
# guards care only about `## [` section headers, so nothing else has to be real.
write_changelog() {
	cat >"$1" <<'MD'
# Changelog

## [0.1.0](https://example.com/compare/v0.0.9..v0.1.0) - 2026-08-05

- something shipped
MD
}

# git-cliff is not installed on every machine that runs this suite, and driving
# the real one would need a fixture repository with tags. The guards under test
# are about what the script does with git-cliff's *output*, so a stub on PATH
# gives exact control over that output and keeps the test hermetic.
make_stub() {
	stub_dir="$work/bin"
	mkdir -p "$stub_dir"
	cat >"$stub_dir/git-cliff" <<STUB
#!/bin/sh
# Emits \$STUB_BODY to the path following --output, ignoring everything else.
while [ "\$#" -gt 0 ]; do
	if [ "\$1" = "--output" ]; then
		printf '%s' "\$STUB_BODY" >"\$2"
		exit 0
	fi
	shift
done
exit 1
STUB
	chmod +x "$stub_dir/git-cliff"
	PATH="$stub_dir:$PATH"
	export PATH
}

# -- argument handling, before any dependency is consulted --

if ! "$STAMP" >/dev/null 2>&1; then
	pass "no arguments is rejected"
else
	fail "no arguments is rejected" "expected a non-zero exit"
fi

if ! "$STAMP" v1.0.0 a b >/dev/null 2>&1; then
	pass "too many arguments is rejected"
else
	fail "too many arguments is rejected" "expected a non-zero exit"
fi

if ! "$STAMP" v1.0.0 "$work/missing.md" >/dev/null 2>&1; then
	pass "a missing changelog is rejected"
else
	fail "a missing changelog is rejected" "expected a non-zero exit"
fi

# The version reaches git-cliff as a tag and the section guard as a grep
# pattern, so a malformed one has to be refused before either sees it. Matching
# the message keeps this honest on machines where git-cliff is absent and the
# script would have exited non-zero anyway.
malformed="$work/malformed.md"
write_changelog "$malformed"
if ! err="$("$STAMP" 1.2 "$malformed" 2>&1)" &&
	printf '%s' "$err" | grep -q 'invalid version'; then
	pass "a malformed version is rejected"
else
	fail "a malformed version is rejected" "expected a non-zero exit and an invalid-version message"
fi

make_stub

# -- what the script does with git-cliff's output --

changelog="$work/CHANGELOG.md"

write_changelog "$changelog"
STUB_BODY="# Changelog

## [0.2.0] - 2026-08-07

- the new thing

## [0.1.0] - 2026-08-05

- something shipped
"
export STUB_BODY
if "$STAMP" v0.2.0 "$changelog" >/dev/null 2>&1 &&
	grep -q '^## \[0.2.0\]' "$changelog" &&
	grep -q '^## \[0.1.0\]' "$changelog"; then
	pass "a well-formed regeneration is published"
else
	fail "a well-formed regeneration is published" "expected both sections present"
fi

# The v0.1.0 failure in this repository: the pending version got no section of
# its own, so its entries had nowhere to live and were dropped.
write_changelog "$changelog"
STUB_BODY="# Changelog

## [0.1.0] - 2026-08-05

- something shipped
"
export STUB_BODY
before="$(cat "$changelog")"
if ! "$STAMP" v0.2.0 "$changelog" >/dev/null 2>&1 && [ "$(cat "$changelog")" = "$before" ]; then
	pass "a regeneration missing the pending version is refused"
else
	fail "a regeneration missing the pending version is refused" \
		"expected a non-zero exit and an unchanged file"
fi

# The shape of the clobber itself: fewer sections out than in.
write_changelog "$changelog"
printf '\n## [0.0.9] - 2026-01-01\n\n- older\n' >>"$changelog"
STUB_BODY="# Changelog

## [0.2.0] - 2026-08-07

- the new thing
"
export STUB_BODY
before="$(cat "$changelog")"
if ! "$STAMP" v0.2.0 "$changelog" >/dev/null 2>&1 && [ "$(cat "$changelog")" = "$before" ]; then
	pass "a regeneration that drops sections is refused"
else
	fail "a regeneration that drops sections is refused" \
		"expected a non-zero exit and an unchanged file"
fi

write_changelog "$changelog"
STUB_BODY=""
export STUB_BODY
before="$(cat "$changelog")"
if ! "$STAMP" v0.2.0 "$changelog" >/dev/null 2>&1 && [ "$(cat "$changelog")" = "$before" ]; then
	pass "an empty regeneration is refused"
else
	fail "an empty regeneration is refused" "expected a non-zero exit and an unchanged file"
fi

# Locating parse-version.sh became load-bearing when the tag started being
# normalized through it, so pin where the lookup happens: next to the script,
# never in the caller's working directory. Invoking through PATH from an
# unrelated directory with a decoy planted there is the case that would tell
# the two apart. The decoy answers v9.9.9, which no stub body contains, so if
# it ever won the section guard would reject the regeneration.
write_changelog "$changelog"
STUB_BODY="# Changelog

## [0.2.0] - 2026-08-07

- the new thing

## [0.1.0] - 2026-08-05

- something shipped
"
export STUB_BODY
decoy_dir="$work/decoy"
mkdir -p "$decoy_dir"
cat >"$decoy_dir/parse-version.sh" <<'DECOY'
#!/bin/sh
echo v9.9.9
DECOY
chmod +x "$decoy_dir/parse-version.sh"
release_dir="$(cd "$TEST_SCRIPT_DIR/../scripts/release" && pwd)"
if (
	cd "$decoy_dir" &&
		PATH="$release_dir:$PATH" stamp-changelog.sh v0.2.0 "$changelog" >/dev/null 2>&1
) && grep -q '^## \[0.2.0\]' "$changelog"; then
	pass "the helper is resolved next to the script, not in the caller's CWD"
else
	fail "the helper is resolved next to the script, not in the caller's CWD" \
		"expected the real parse-version.sh to win over a decoy in the CWD"
fi

echo
echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
[ "$FAILED" -eq 0 ]
