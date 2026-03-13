#!/bin/sh
# shellcheck disable=SC2034,SC2176,SC2177
# Benchmark with multiple different strings to understand case statement behavior

ITERATIONS=100000

test_cases="Revert commit abc123
revert commit abc123
Reapply commit abc123
reapply commit abc123"

echo "Testing 4 different strings in rotation"
echo "Iterations: $ITERATIONS per test case"
echo ""

benchmark_previous() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		for stripped in $test_cases; do
			case "$stripped" in
			[Rr]evert*)
				rest="${stripped#??????}"
				result="revert: revert$rest"
				;;
			[Rr]eapply*)
				rest="${stripped#???????}"
				result="revert: reapply$rest"
				;;
			esac
		done
		i=$((i + 1))
	done
}

benchmark_new() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		for stripped in $test_cases; do
			rest="${stripped#?}"
			result="revert: r$rest"
		done
		i=$((i + 1))
	done
}

# PREVIOUS: Case statement with pattern matching
echo "=== PREVIOUS: Case statement [Rr]evert* / [Rr]eapply* ==="
time benchmark_previous 2>&1 | grep -E "real|user|sys"

# NEW: No case statement
echo ""
echo "=== NEW: Direct parameter expansion (no case) ==="
time benchmark_new 2>&1 | grep -E "real|user|sys"

echo ""
echo "Key difference: Case statement can short-circuit pattern matching"
echo "but also has overhead. Parameter expansion is always executed."
