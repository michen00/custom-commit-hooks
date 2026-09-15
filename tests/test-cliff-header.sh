#!/usr/bin/env bash
# Test script for the [changelog] header template in cliff.toml

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared configurations
# shellcheck disable=SC1091 # Dynamic path via $TEST_SCRIPT_DIR
. "$TEST_SCRIPT_DIR/colors.sh"

CLIFF_TOML="$TEST_SCRIPT_DIR/../cliff.toml"

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

# Render the header template the way TOML does, so the assertions below run
# against the text git-cliff actually writes. git-cliff is not installed on
# every machine that runs this suite (and not in CI at all), and the header is
# static text with no Tera expressions, so decoding it here is both sufficient
# and portable.
#
# TOML multi-line basic strings drop the newline right after the opening
# delimiter; every other source line contributes its text plus one newline, and
# a trailing \n escape contributes another newline on top of that. That second
# newline is easy to add by accident and invisible in the source, which is what
# MD012 below is guarding against.
render_header() {
	awk '
	/^header = """$/ { in_block = 1; next }
	in_block && /^"""$/ { exit }
	in_block {
		line = $0
		extra = 0
		while (sub(/\\n$/, "", line)) extra++
		if (line ~ /\\/) {
			print "unsupported escape in header template: " $0 > "/dev/stderr"
			exit 1
		}
		print line
		for (i = 0; i < extra; i++) print ""
	}
	' "$1"
}

if ! work="$(mktemp -d)"; then
	echo "Error: could not create a temporary directory" >&2
	exit 1
fi
trap 'rm -rf "$work"' EXIT INT TERM HUP
rendered="$work/header.md"

if ! render_header "$CLIFF_TOML" >"$rendered"; then
	fail "header template renders" "render_header could not decode the template"
elif [ ! -s "$rendered" ]; then
	fail "header template renders" "Rendered header is empty; is the 'header = \"\"\"' block still there?"
else
	pass "header template renders"

	# MD012/no-multiple-blanks. markdownlint runs over the generated changelog
	# in the changelog-autoupdate workflow, and a header that trips this rule
	# fails that job every week without ever touching a commit.
	offenders="$(awk 'BEGIN { run = 0 } { if ($0 == "") { run++; if (run > 1) print NR } else run = 0 }' "$rendered")"
	if [ -n "$offenders" ]; then
		# shellcheck disable=SC2086 # Word splitting turns the line list into args
		fail "header has no consecutive blank lines (MD012)" \
			"Extra blank lines at rendered line(s): $(echo $offenders | tr ' ' ',')" \
			"Rendered header:" \
			"$(cat -v "$rendered")"
	else
		pass "header has no consecutive blank lines (MD012)"
	fi

	# The header has to end with exactly one blank line so the first '## ['
	# section that follows it is separated by one blank line, not glued on.
	trailing_blanks="$(awk '{ if ($0 == "") blanks++; else blanks = 0 } END { print blanks + 0 }' "$rendered")"
	if [ "$trailing_blanks" -ne 1 ]; then
		fail "header ends with a single blank line" \
			"Header ends with $trailing_blanks trailing blank line(s), expected 1"
	else
		pass "header ends with a single blank line"
	fi
fi

echo ""
echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
[ "$FAILED" -eq 0 ]
