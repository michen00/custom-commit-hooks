#!/usr/bin/env bash
# Test script for scripts/release/parse-version.sh
# shellcheck disable=SC2016 # Metacharacter payloads are deliberately unexpanded

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared configurations
# shellcheck disable=SC1091 # Dynamic path via $TEST_SCRIPT_DIR
. "$TEST_SCRIPT_DIR/colors.sh"

PARSE_VERSION="$TEST_SCRIPT_DIR/../scripts/release/parse-version.sh"

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

# assert_accepts <expected_tag> <input> [flag]
assert_accepts() {
	local expected="$1"
	local input="$2"
	shift 2
	local output status
	output="$(sh "$PARSE_VERSION" "$input" "$@" 2>/dev/null)"
	status=$?

	if [ "$status" -ne 0 ]; then
		fail "accepts '$input' ${*:+($*) }" "Exited $status, expected 0"
	elif [ "$output" != "$expected" ]; then
		fail "accepts '$input' ${*:+($*) }" "Got '$output', expected '$expected'"
	else
		pass "'$input' ${*:+($*) }-> $expected"
	fi
}

# assert_rejects <input> [flag]
assert_rejects() {
	local input="$1"
	shift
	local output status
	output="$(sh "$PARSE_VERSION" "$input" "$@" 2>/dev/null)"
	status=$?

	if [ "$status" -eq 0 ]; then
		fail "rejects '$input' ${*:+($*) }" "Exited 0 and printed '$output'"
	elif [ -n "$output" ]; then
		fail "rejects '$input' ${*:+($*) }" "Printed '$output' on stdout; expected nothing"
	else
		pass "rejects '$input' ${*:+($*) }"
	fi
}

printf "Testing scripts/release/parse-version.sh...\n\n"

# Well-formed versions, both spellings
assert_accepts 'v1.2.3' 'v1.2.3'
assert_accepts 'v1.2.3' '1.2.3'
assert_accepts 'v0.0.0' 'v0.0.0'
assert_accepts 'v0.1.0' 'v0.1.0'
assert_accepts 'v10.20.30' 'v10.20.30'
assert_accepts 'v1.2.3' 'v1.2.3' --require-v
assert_accepts 'v0.0.4' 'v0.0.4' --require-v

# Multi-digit and zero-prefixed components stay untouched
assert_accepts 'v100.200.300' '100.200.300'

# Shell metacharacters must never survive validation. A glob such as
# v[0-9]*.[0-9]*.[0-9]* accepts all of these, which is why it is not used.
assert_rejects 'v1.0.0; rm -rf /'
assert_rejects 'v1.0.0 && id'
assert_rejects 'v1.0.0$(id)'
assert_rejects 'v1.0.0`id`'
assert_rejects 'v1.0.0 --force'
assert_rejects 'v1.0.0
v2.0.0'
assert_rejects '1.2.3;id'
assert_rejects 'v1.0.0|tee'

# Wrong number of components
assert_rejects 'v1'
assert_rejects 'v1.2'
assert_rejects 'v1.2.3.4'
assert_rejects '1.2'

# Empty or non-numeric components
assert_rejects ''
assert_rejects 'v'
assert_rejects 'v..'
assert_rejects 'v1..3'
assert_rejects 'v.2.3'
assert_rejects 'v1.2.'
assert_rejects 'vX.Y.Z'
assert_rejects 'v-1.2.3'
assert_rejects 'v1.-2.3'
assert_rejects 'vv1.2.3'
assert_rejects 'v1.2.3-rc1'
assert_rejects 'v1.2.3+build'
assert_rejects ' v1.2.3'
assert_rejects 'v1.2.3 '

# --require-v rejects the bare form that the default mode accepts
assert_rejects '1.2.3' --require-v
assert_rejects '0.0.4' --require-v

# Argument errors exit 2 rather than 1
for args in '' 'a b c'; do
	# shellcheck disable=SC2086 # Intentional word splitting to vary arg count
	sh "$PARSE_VERSION" $args >/dev/null 2>&1
	status=$?
	if [ "$status" -eq 2 ]; then
		pass "usage error for [$args] exits 2"
	else
		fail "usage error for [$args]" "Exited $status, expected 2"
	fi
done

sh "$PARSE_VERSION" 'v1.2.3' --bogus >/dev/null 2>&1
status=$?
if [ "$status" -eq 2 ]; then
	pass "unknown flag exits 2"
else
	fail "unknown flag" "Exited $status, expected 2"
fi

# Errors go to stderr, never stdout
stderr="$(sh "$PARSE_VERSION" 'nope' 2>&1 >/dev/null)"
if [ -n "$stderr" ]; then
	pass "invalid input writes a message to stderr"
else
	fail "invalid input writes a message to stderr" "stderr was empty"
fi

printf "\nResults: ${GREEN}%d passed${NC}, ${RED}%d failed${NC}\n" "$PASSED" "$FAILED"

[ "$FAILED" -eq 0 ]
