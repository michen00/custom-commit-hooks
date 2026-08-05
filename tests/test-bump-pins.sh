#!/usr/bin/env bash
# Test script for scripts/release/bump-pins.sh

set -uo pipefail
TEST_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared configurations
# shellcheck disable=SC1091 # Dynamic path via $TEST_SCRIPT_DIR
. "$TEST_SCRIPT_DIR/colors.sh"

BUMP_PINS="$TEST_SCRIPT_DIR/../scripts/release/bump-pins.sh"

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

# A config carrying both this repo's pin and third-party pins at the same version,
# which is the case a naive search-and-replace on the old version would corrupt.
write_config() {
	cat >"$1" <<'YAML'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v0.0.4
    hooks:
      - id: check-yaml
  - repo: https://github.com/michen00/custom-commit-hooks
    rev: v0.0.4
    hooks:
      - id: enhance-scope
  - repo: https://github.com/jorisroovers/gitlint
    rev: v0.0.4
    hooks:
      - id: gitlint
YAML
}

write_readme() {
	cat >"$1" <<'MD'
# Example

```yaml
repos:
  - repo: https://github.com/michen00/custom-commit-hooks
    rev: v0.0.4 # Use the latest version
    hooks:
      - id: enhance-scope
```
MD
}

printf "Testing scripts/release/bump-pins.sh...\n\n"

# --- only this repo's pin moves ---
cfg="$work/config.yaml"
write_config "$cfg"
sh "$BUMP_PINS" v0.1.0 "$cfg" >/dev/null 2>&1
own=$(awk '/michen00\/custom-commit-hooks/{getline; print $2}' "$cfg")
third=$(grep -c 'rev: v0.0.4' "$cfg")
if [ "$own" = "v0.1.0" ]; then
	pass "this repo's pin bumped to v0.1.0"
else
	fail "this repo's pin bumped" "Got '$own'"
fi
if [ "$third" -eq 2 ]; then
	pass "both third-party pins at the same version left untouched"
else
	fail "third-party pins untouched" "Expected 2 remaining v0.0.4, got $third"
fi

# --- armed state must not leak past a non-matching repo: line ---
# A block for this repo carrying no rev: previously left the matcher armed, so the
# NEXT repo's rev: got rewritten and the script still exited 0 — silently bumping a
# third party while leaving the intended pin untouched.
leak="$work/leak.yaml"
cat >"$leak" <<'YAML'
repos:
  - repo: https://github.com/michen00/custom-commit-hooks
    hooks:
      - id: enhance-scope
  - repo: https://github.com/jorisroovers/gitlint
    rev: v0.19.1
    hooks:
      - id: gitlint
YAML
sh "$BUMP_PINS" v0.1.0 "$leak" >/dev/null 2>&1
leak_status=$?
if grep -q 'rev: v0\.19\.1' "$leak"; then
	pass "third-party rev untouched when this repo's block has no rev"
else
	fail "third-party rev untouched when this repo's block has no rev" \
		"Got: $(grep 'rev:' "$leak")"
fi
if [ "$leak_status" -eq 3 ]; then
	pass "reports no-pin-found rather than a false success"
else
	fail "reports no-pin-found rather than a false success" "Exited $leak_status"
fi

# --- trailing comment and indentation survive ---
rdm="$work/README.md"
write_readme "$rdm"
sh "$BUMP_PINS" v0.1.0 "$rdm" >/dev/null 2>&1
if grep -q '^    rev: v0\.1\.0 # Use the latest version$' "$rdm"; then
	pass "indentation and trailing comment preserved"
else
	fail "indentation and trailing comment preserved" "Got: $(grep 'rev:' "$rdm")"
fi

# --- idempotent ---
before="$(cat "$rdm")"
sh "$BUMP_PINS" v0.1.0 "$rdm" >/dev/null 2>&1
if [ "$before" = "$(cat "$rdm")" ]; then
	pass "second run with the same tag is a no-op"
else
	fail "second run is a no-op" "File changed on re-run"
fi

# --- multiple files in one invocation ---
write_config "$cfg"
write_readme "$rdm"
sh "$BUMP_PINS" v2.3.4 "$cfg" "$rdm" >/dev/null 2>&1
c_own=$(awk '/michen00\/custom-commit-hooks/{getline; print $2}' "$cfg")
r_own=$(awk '/michen00\/custom-commit-hooks/{getline; print $2}' "$rdm")
if [ "$c_own" = "v2.3.4" ] && [ "$r_own" = "v2.3.4" ]; then
	pass "bumps every file passed in one invocation"
else
	fail "bumps every file" "config='$c_own' readme='$r_own'"
fi

# --- bare version is normalized ---
write_config "$cfg"
sh "$BUMP_PINS" 3.4.5 "$cfg" >/dev/null 2>&1
if [ "$(awk '/michen00\/custom-commit-hooks/{getline; print $2}' "$cfg")" = "v3.4.5" ]; then
	fail "bare version rejected" "Accepted bare 3.4.5; --require-v should reject it"
else
	pass "bare version without leading v is rejected"
fi

# --- a file with no pin for this repo fails loudly (exit 3) ---
none="$work/none.yaml"
printf 'repos:\n  - repo: https://github.com/other/thing\n    rev: v1.0.0\n' >"$none"
sh "$BUMP_PINS" v0.1.0 "$none" >/dev/null 2>&1
status=$?
if [ "$status" -eq 3 ]; then
	pass "file without this repo's pin exits 3"
else
	fail "file without this repo's pin exits 3" "Exited $status"
fi

# --- argument and tag validation ---
sh "$BUMP_PINS" >/dev/null 2>&1
status=$?
if [ "$status" -eq 2 ]; then
	pass "missing tag exits 2"
else
	fail "missing tag exits 2" "Exited $status"
fi

sh "$BUMP_PINS" 'v1.0.0; rm -rf /' "$cfg" >/dev/null 2>&1
status=$?
if [ "$status" -ne 0 ]; then
	pass "metacharacter payload in tag is rejected"
else
	fail "metacharacter payload in tag is rejected" "Exited 0"
fi

sh "$BUMP_PINS" v9.9.9 "$work/missing.yaml" >/dev/null 2>&1
status=$?
if [ "$status" -eq 2 ]; then
	pass "missing file exits 2"
else
	fail "missing file exits 2" "Exited $status"
fi

# --- the real README carries a bumpable pin ---
cp "$TEST_SCRIPT_DIR/../README.md" "$work/README.real"
if sh "$BUMP_PINS" v9.9.9 "$work/README.real" >/dev/null 2>&1 &&
	grep -q 'rev: v9\.9\.9' "$work/README.real"; then
	pass "the real README.md carries a pin this script can bump"
else
	fail "the real README.md carries a bumpable pin" "Bump did not apply"
fi

# --- default target is README.md alone ---
# .pre-commit-config.yaml must NOT be bumped during a release: pre-commit resolves
# a rev by checking it out, and the release tag does not exist until the release PR
# merges, so pinning the pending version fails that PR's own checks with
# "pathspec 'vX.Y.Z' did not match any file(s) known to git".
default_targets="$(grep -A 1 'if \[ "\$#" -eq 0 \]' "$BUMP_PINS" | tail -1)"
if printf '%s' "$default_targets" | grep -q 'README.md' &&
	! printf '%s' "$default_targets" | grep -q 'pre-commit-config'; then
	pass "default target list is README.md only, excluding the self-pin"
else
	fail "default target list excludes .pre-commit-config.yaml" "Got: $default_targets"
fi

# --- but an explicit config path still works, for post-tag manual bumps ---
write_config "$cfg"
if sh "$BUMP_PINS" v5.6.7 "$cfg" >/dev/null 2>&1 &&
	[ "$(awk '/michen00\/custom-commit-hooks/{getline; print $2}' "$cfg")" = "v5.6.7" ]; then
	pass "explicitly passed config file is still bumpable"
else
	fail "explicitly passed config file is bumpable" "Bump did not apply"
fi

printf "\nResults: ${GREEN}%d passed${NC}, ${RED}%d failed${NC}\n" "$PASSED" "$FAILED"

[ "$FAILED" -eq 0 ]
