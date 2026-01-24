#!/usr/bin/env bash
# Run kcov with the given output directory and test script

set -euo pipefail

output_dir="${1:-}"
test_script="${2:-}"
include_path="${3:-$PWD/scripts}"

if [ -z "$output_dir" ] || [ -z "$test_script" ]; then
	echo "Usage: $0 <output_dir> <test_script> [include_path]" >&2
	exit 1
fi

sudo apt-get update
sudo apt-get install -y \
	binutils-dev \
	build-essential \
	cmake \
	libssl-dev \
	libcurl4-openssl-dev \
	libelf-dev \
	libstdc++-12-dev \
	zlib1g-dev \
	libdw-dev \
	libiberty-dev

if ! command -v kcov >/dev/null 2>&1; then
	git clone https://github.com/SimonKagstrom/kcov.git --depth 1
	cmake -S kcov -B kcov/build
	cmake --build kcov/build -j"$(nproc)"
	sudo cmake --install kcov/build
fi

kcov --include-path="$include_path" "$output_dir" bash "$test_script"

if [ -n "${GITHUB_OUTPUT:-}" ]; then
	{
		echo "coverage<<EOF"
		cat "$output_dir/coverage.json"
		echo "EOF"
	} >>"$GITHUB_OUTPUT"
fi
