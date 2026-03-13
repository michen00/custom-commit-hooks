#!/bin/sh
# shellcheck disable=SC2034,SC2176,SC2177
# Detailed benchmark to understand performance differences

ITERATIONS=500000

test_string="Revert commit abc123"

echo "Testing single string: '$test_string'"
echo "Iterations: $ITERATIONS"
echo ""

benchmark_case_pattern() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		stripped="$test_string"
		case "$stripped" in
		[Rr]evert*)
			rest="${stripped#??????}"
			result="revert: revert$rest"
			;;
		esac
		i=$((i + 1))
	done
}

benchmark_direct_expansion() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		stripped="$test_string"
		rest="${stripped#?}"
		result="revert: r$rest"
		i=$((i + 1))
	done
}

benchmark_fixed_length() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		stripped="$test_string"
		rest="${stripped#??????}"
		result="revert: revert$rest"
		i=$((i + 1))
	done
}

# Test 1: Case statement with pattern matching
echo "=== Case statement pattern matching [Rr]evert* ==="
time benchmark_case_pattern 2>&1 | grep -E "real|user|sys"

# Test 2: Direct parameter expansion (no case)
echo ""
echo "=== Direct parameter expansion (no case) ==="
time benchmark_direct_expansion 2>&1 | grep -E "real|user|sys"

# Test 3: Parameter expansion with fixed length
echo ""
echo "=== Parameter expansion with fixed length #?????? ==="
time benchmark_fixed_length 2>&1 | grep -E "real|user|sys"

# Test 4: Parameter expansion with single char
echo ""
echo "=== Parameter expansion with single char #? ==="
time benchmark_direct_expansion 2>&1 | grep -E "real|user|sys"

echo ""
echo "Analysis complete!"
