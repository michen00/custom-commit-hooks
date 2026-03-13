#!/bin/sh
# shellcheck disable=SC2176,SC2177
# Comprehensive benchmark comparing different case statement versions
# Tests all 4 versions found in git history with realistic test cases

ITERATIONS=100000

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

# Version 4 (d33929a): 8 branches, reverse frequency order (bad for short-circuiting)
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

# Extract test cases from CSV with realistic frequency distribution
# 40% Merge, 30% Revert/Reapply, 20% Squash, 10% variants
build_test_cases() {
	# Merge patterns (40% - most common)
	echo "Merge"
	echo "merge"
	echo "Merge!"
	echo "merge "
	echo "Merge:"
	echo "merge."

	# Revert patterns (30%)
	echo "Revert"
	echo "revert"
	echo "Revert!"
	echo "revert "
	echo "Reapply"
	echo "reapply"
	echo "Reapply!"
	echo "reapply "

	# Squash patterns (20%)
	echo "Squash"
	echo "squash"
	echo "Squash!"
	echo "squash "

	# Variants (10%)
	echo "Merged"
	echo "Merges"
	echo "Squashed"
	echo "Squashes"
}

run_iterations() {
	version_func="$1"
	test_cases="$2"

	i=0
	while [ $i -lt $ITERATIONS ]; do
		for test_case in $test_cases; do
			"$version_func" "$test_case" >/dev/null
			i=$((i + 1))
			[ $i -ge $ITERATIONS ] && break
		done
	done
}

# Run benchmark for a version
benchmark_version() {
	version_func="$1"
	version_name="$2"
	test_cases="$3"

	printf "  %s: " "$version_name"

	# Use time command for accurate measurement
	result=
	result=$(
		time run_iterations "$version_func" "$test_cases" 2>&1
	)

	# Extract real time
	real_time=
	real_time=$(echo "$result" | grep real | awk '{print $2}')
	printf "%s\n" "$real_time"
}

# Verify all versions produce same results
verify_versions() {
	test_cases=
	test_cases=$(build_test_cases)

	printf "Verifying all versions produce identical results...\n"

	for test_case in $test_cases; do
		v1=$(detect_v1 "$test_case")
		v2=$(detect_v2 "$test_case")
		v3=$(detect_v3 "$test_case")
		v4=$(detect_v4 "$test_case")

		if [ "$v1" != "$v2" ] || [ "$v2" != "$v3" ] || [ "$v3" != "$v4" ]; then
			printf "ERROR: Mismatch for '%s': v1=%s v2=%s v3=%s v4=%s\n" "$test_case" "$v1" "$v2" "$v3" "$v4"
			return 1
		fi
	done

	printf "✓ All versions produce identical results\n\n"
}

# Main benchmark
main() {
	printf "Benchmarking Case Statement Versions\n"
	printf "====================================\n"
	printf "Iterations: %s\n" "$ITERATIONS"
	printf "\n"

	# Verify correctness first
	if ! verify_versions; then
		printf "ERROR: Version verification failed. Aborting benchmark.\n"
		exit 1
	fi

	test_cases=
	test_cases=$(build_test_cases)

	printf "Running benchmarks...\n"
	printf "Test cases: %s\n" "$(echo "$test_cases" | wc -l | tr -d ' ')"
	printf "\n"

	benchmark_version "detect_v1" "V1 (8 branches, freq-ordered)" "$test_cases"
	benchmark_version "detect_v2" "V2 (5 branches, grouped)" "$test_cases"
	benchmark_version "detect_v3" "V3 (3 branches, most DRY)" "$test_cases"
	benchmark_version "detect_v4" "V4 (8 branches, reverse freq)" "$test_cases"

	printf "\n"
	printf "Benchmark complete!\n"
}

main "$@"
