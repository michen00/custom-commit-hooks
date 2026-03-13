#!/bin/sh
# shellcheck disable=SC2176,SC2177
# Detailed benchmark testing each pattern category separately

ITERATIONS=50000

# Version 1 (ccdcb68): 8 separate branches, frequency-ordered
detect_v1() {
	case "$1" in
	[Mm]erge | [Mm]erge[![:alnum:]_]*) echo "merge" ;;
	[Rr]evert | [Rr]evert[![:alnum:]_]*) echo "revert" ;;
	[Rr]eapply | [Rr]eapply[![:alnum:]_]*) echo "revert" ;;
	[Ss]quash | [Ss]quash[![:alnum:]_]*) echo "squash" ;;
	[Mm]erged | [Mm]erged[![:alnum:]_]*) echo "merge" ;;
	[Mm]erges | [Mm]erges[![:alnum:]_]*) echo "merge" ;;
	[Ss]quashed | [Ss]quashed[![:alnum:]_]*) echo "squash" ;;
	[Ss]quashes | [Ss]quashes[![:alnum:]_]*) echo "squash" ;;
	esac
}

# Version 2 (7dd41ec): 5 branches, partially grouped
detect_v2() {
	case "$1" in
	[Mm]erge | [Mm]erge[![:alnum:]_]*) echo "merge" ;;
	[Rr]evert | [Rr]evert[![:alnum:]_]* | [Rr]eapply | [Rr]eapply[![:alnum:]_]*) echo "revert" ;;
	[Ss]quash | [Ss]quash[![:alnum:]_]*) echo "squash" ;;
	[Mm]erged | [Mm]erged[![:alnum:]_]* | [Mm]erges | [Mm]erges[![:alnum:]_]*) echo "merge" ;;
	[Ss]quashed | [Ss]quashed[![:alnum:]_]* | [Ss]quashes | [Ss]quashes[![:alnum:]_]*) echo "squash" ;;
	esac
}

# Version 3 (eb7c13c/current): 3 branches, most DRY
detect_v3() {
	case "$1" in
	[Mm]erge | [Mm]erge[ds] | [Mm]erge[![:alnum:]_]* | [Mm]erge[ds][![:alnum:]_]*) echo "merge" ;;
	[Rr]evert | [Rr]evert[![:alnum:]_]* | [Rr]eapply | [Rr]eapply[![:alnum:]_]*) echo "revert" ;;
	[Ss]quash | [Ss]quashe[ds] | [Ss]quash[![:alnum:]_]* | [Ss]quashe[ds][![:alnum:]_]*) echo "squash" ;;
	esac
}

# Version 4 (d33929a): 8 branches, reverse frequency order
detect_v4() {
	case "$1" in
	[Mm]erges | [Mm]erges[![:alnum:]_]*) echo "merge" ;;
	[Mm]erged | [Mm]erged[![:alnum:]_]*) echo "merge" ;;
	[Mm]erge | [Mm]erge[![:alnum:]_]*) echo "merge" ;;
	[Ss]quashes | [Ss]quashes[![:alnum:]_]*) echo "squash" ;;
	[Ss]quashed | [Ss]quashed[![:alnum:]_]*) echo "squash" ;;
	[Ss]quash | [Ss]quash[![:alnum:]_]*) echo "squash" ;;
	[Rr]eapply | [Rr]eapply[![:alnum:]_]*) echo "revert" ;;
	[Rr]evert | [Rr]evert[![:alnum:]_]*) echo "revert" ;;
	esac
}

run_iterations() {
	version_func="$1"
	test_case="$2"

	i=0
	while [ $i -lt $ITERATIONS ]; do
		"$version_func" "$test_case" >/dev/null
		i=$((i + 1))
	done
}

# Benchmark a specific pattern category
benchmark_category() {
	version_func="$1"
	version_name="$2"
	test_case="$3"

	printf "    %s: " "$version_name"

	result=
	result=$(
		time run_iterations "$version_func" "$test_case" 2>&1
	)

	real_time=
	real_time=$(echo "$result" | grep real | awk '{print $2}')
	printf "%s\n" "$real_time"
}

main() {
	printf "Detailed Benchmark: Individual Pattern Performance\n"
	printf "==================================================\n"
	printf "Iterations per test: %s\n" "$ITERATIONS"
	printf "\n"

	# Test Merge (most common - should be fastest in V1, V2, V3)
	printf "=== Merge (most common pattern) ===\n"
	benchmark_category "detect_v1" "V1" "Merge"
	benchmark_category "detect_v2" "V2" "Merge"
	benchmark_category "detect_v3" "V3" "Merge"
	benchmark_category "detect_v4" "V4" "Merge"
	printf "\n"

	# Test Revert (second most common)
	printf "=== Revert (second most common) ===\n"
	benchmark_category "detect_v1" "V1" "Revert"
	benchmark_category "detect_v2" "V2" "Revert"
	benchmark_category "detect_v3" "V3" "Revert"
	benchmark_category "detect_v4" "V4" "Revert"
	printf "\n"

	# Test Squash (third most common)
	printf "=== Squash (third most common) ===\n"
	benchmark_category "detect_v1" "V1" "Squash"
	benchmark_category "detect_v2" "V2" "Squash"
	benchmark_category "detect_v3" "V3" "Squash"
	benchmark_category "detect_v4" "V4" "Squash"
	printf "\n"

	# Test Merged (less common variant - worst case for V4)
	printf "=== Merged (variant - worst case for V4) ===\n"
	benchmark_category "detect_v1" "V1" "Merged"
	benchmark_category "detect_v2" "V2" "Merged"
	benchmark_category "detect_v3" "V3" "Merged"
	benchmark_category "detect_v4" "V4" "Merged"
	printf "\n"

	# Test Squashed (least common variant)
	printf "=== Squashed (variant) ===\n"
	benchmark_category "detect_v1" "V1" "Squashed"
	benchmark_category "detect_v2" "V2" "Squashed"
	benchmark_category "detect_v3" "V3" "Squashed"
	benchmark_category "detect_v4" "V4" "Squashed"
	printf "\n"

	printf "Benchmark complete!\n"
}

main "$@"
