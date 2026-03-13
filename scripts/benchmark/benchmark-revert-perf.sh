#!/bin/sh
# shellcheck disable=SC2034,SC2176,SC2177
# Benchmark script to compare revert string removal performance

# Test strings
test_cases="Revert commit abc123
revert commit abc123
Reapply commit abc123
reapply commit abc123"

# Number of iterations
ITERATIONS=10000

echo "Benchmarking string removal operations..."
echo "Iterations: $ITERATIONS"
echo ""

benchmark_old() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		for stripped in $test_cases; do
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
		done
		i=$((i + 1))
	done
}

benchmark_new() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		for stripped in $test_cases; do
			case "$stripped" in
			[Rr]evert*)
				rest="${stripped#??????}"
				;;
			[Rr]eapply*)
				rest="${stripped#???????}"
				;;
			esac
		done
		i=$((i + 1))
	done
}

benchmark_hybrid() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		for stripped in $test_cases; do
			case "$stripped" in
			[Rr]evert*)
				# Use exact removal based on first char
				case "$stripped" in
				Revert*) rest="${stripped#Revert}" ;;
				revert*) rest="${stripped#revert}" ;;
				esac
				;;
			[Rr]eapply*)
				case "$stripped" in
				Reapply*) rest="${stripped#Reapply}" ;;
				reapply*) rest="${stripped#reapply}" ;;
				esac
				;;
			esac
		done
		i=$((i + 1))
	done
}

# Test 1: Old approach - exact string removal (4 case branches)
echo "=== OLD: 4 case branches with exact string removal ==="
time benchmark_old 2>&1 | grep -E "real|user|sys"

echo ""

# Test 2: New approach - pattern-based removal (2 case branches)
echo "=== NEW: 2 case branches with pattern-based removal ==="
time benchmark_new 2>&1 | grep -E "real|user|sys"

echo ""

# Test 3: Hybrid - 2 case branches with exact string removal (best of both?)
echo "=== HYBRID: 2 case branches with exact string removal ==="
time benchmark_hybrid 2>&1 | grep -E "real|user|sys"

exit 0
