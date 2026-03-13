#!/bin/sh
# shellcheck disable=SC2034,SC2176,SC2177
# Benchmark comparing old, previous, and new revert/reapply handling approaches

ITERATIONS=100000

test_cases="Revert commit abc123
revert commit abc123
Reapply commit abc123
reapply commit abc123"

echo "Benchmarking revert/reapply string transformation"
echo "Iterations: $ITERATIONS per test case"
echo ""

benchmark_old() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		for stripped in $test_cases; do
			case "$stripped" in
			Revert*)
				rest="${stripped#Revert}"
				new_first_line="revert: revert$rest"
				;;
			revert*)
				rest="${stripped#revert}"
				new_first_line="revert: revert$rest"
				;;
			Reapply*)
				rest="${stripped#Reapply}"
				new_first_line="revert: reapply$rest"
				;;
			reapply*)
				rest="${stripped#reapply}"
				new_first_line="revert: reapply$rest"
				;;
			esac
		done
		i=$((i + 1))
	done
}

benchmark_previous() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		for stripped in $test_cases; do
			case "$stripped" in
			[Rr]evert*)
				rest="${stripped#??????}"
				new_first_line="revert: revert$rest"
				;;
			[Rr]eapply*)
				rest="${stripped#???????}"
				new_first_line="revert: reapply$rest"
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
			new_first_line="revert: r$rest"
		done
		i=$((i + 1))
	done
}

# OLD: 4 case branches with exact string removal
echo "=== OLD: 4 case branches (Revert*, revert*, Reapply*, reapply*) ==="
time benchmark_old 2>&1 | grep -E "real|user|sys"

echo ""

# PREVIOUS: 2 case branches with pattern-based removal (magic numbers)
echo "=== PREVIOUS: 2 case branches with pattern removal (??????, ???????) ==="
time benchmark_previous 2>&1 | grep -E "real|user|sys"

echo ""

# NEW: No case statement, single parameter expansion
echo "=== NEW: No case statement, single parameter expansion (r\$rest) ==="
time benchmark_new 2>&1 | grep -E "real|user|sys"

echo ""
echo "Benchmark complete!"
