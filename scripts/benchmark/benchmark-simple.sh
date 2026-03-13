#!/bin/sh
# shellcheck disable=SC2034,SC2176,SC2177
# Simple benchmark comparing old vs new approach

ITERATIONS=50000

test_string="Revert commit abc123"

echo "Benchmarking $ITERATIONS iterations with: '$test_string'"
echo ""

old_benchmark() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		stripped="$test_string"
		case "$stripped" in
		Revert*)
			rest="${stripped#Revert}"
			;;
		revert*)
			rest="${stripped#revert}"
			;;
		Reapply*)
			rest="${stripped#Reapply}"
			;;
		reapply*)
			rest="${stripped#reapply}"
			;;
		esac
		i=$((i + 1))
	done
}

new_benchmark() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		stripped="$test_string"
		case "$stripped" in
		[Rr]evert*)
			rest="${stripped#??????}"
			;;
		[Rr]eapply*)
			rest="${stripped#???????}"
			;;
		esac
		i=$((i + 1))
	done
}

# OLD: 4 case branches
echo "OLD (4 branches, exact removal):"
time old_benchmark 2>&1 | tail -1

# NEW: 2 case branches
echo "NEW (2 branches, pattern removal):"
time new_benchmark 2>&1 | tail -1
