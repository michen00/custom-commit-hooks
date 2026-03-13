#!/bin/sh
# shellcheck disable=SC2034,SC2176,SC2177
# Complete benchmark testing all revert/reapply cases

ITERATIONS=20000

echo "Benchmarking $ITERATIONS iterations for each case"
echo ""

old_case_benchmark() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		stripped="$test_case"
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

new_case_benchmark() {
	i=1
	while [ $i -le $ITERATIONS ]; do
		stripped="$test_case"
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

for test_case in "Revert commit abc123" "revert commit abc123" "Reapply commit abc123" "reapply commit abc123"; do
	echo "Testing: '$test_case'"

	# OLD approach
	printf "  OLD: "
	time old_case_benchmark 2>&1 | grep real | awk '{print $2}'

	# NEW approach
	printf "  NEW: "
	time new_case_benchmark 2>&1 | grep real | awk '{print $2}'

	echo ""
done
