#!/bin/sh
# Run one or all benchmark scripts in this directory.
# Usage: run.sh [--list] [name...]
#   --list       List available benchmarks and exit.
#   name         Run benchmark(s) by short name (e.g. simple, case-versions).
#   (no args)    Run all benchmarks.

script_dir="$(CDPATH='' cd -- "$(dirname "$0")" && pwd)"

list_benchmarks() {
	for f in "$script_dir"/benchmark-*.sh; do
		[ -f "$f" ] || continue
		base=$(basename "$f" .sh)
		printf "%s\n" "${base#benchmark-}"
	done | sort
}

run_one() {
	short="$1"
	path="$script_dir/benchmark-${short}.sh"
	if [ ! -f "$path" ]; then
		echo "Error: no benchmark '$short' (expected $path)" >&2
		return 1
	fi
	printf "\n=== %s ===\n" "benchmark-$short"
	sh "$path"
}

main() {
	if [ "$1" = "--list" ]; then
		list_benchmarks
		return 0
	fi

	if [ $# -eq 0 ]; then
		for name in $(list_benchmarks); do
			run_one "$name" || true
		done
		return 0
	fi

	failed=0
	for name in "$@"; do
		run_one "$name" || failed=1
	done
	return $failed
}

main "$@"
