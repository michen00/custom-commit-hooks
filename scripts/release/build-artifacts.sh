#!/bin/sh

set -eu

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
	echo "Usage: $0 <tag> [output_dir]" >&2
	exit 1
fi

tag="$1"
out_dir="${2:-dist}"

case "$tag" in
v[0-9]*.[0-9]*.[0-9]*) ;;
*)
	echo "Error: tag must match vX.Y.Z (for example: v0.1.0)" >&2
	exit 1
	;;
esac

script_dir="$(CDPATH='' cd -- "$(dirname "$0")" && pwd)"
repo_root="$(CDPATH='' cd -- "$script_dir/../.." && pwd)"

case "$out_dir" in
/*) ;;
*) out_dir="$repo_root/$out_dir" ;;
esac

if ! command -v zip >/dev/null 2>&1; then
	echo "Error: zip command is required to build release artifacts" >&2
	exit 1
fi

bundle_name="custom-commit-hooks-$tag"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/custom-commit-hooks-release.XXXXXX")"
cleanup() {
	rm -rf "$tmp_dir"
}
trap cleanup EXIT HUP INT TERM

stage_dir="$tmp_dir/$bundle_name"
mkdir -p "$stage_dir/scripts/lib"
mkdir -p "$out_dir"

copy_release_file() {
	src="$1"
	dst="$2"

	if [ ! -f "$repo_root/$src" ]; then
		echo "Error: required file missing: $src" >&2
		exit 1
	fi

	cp "$repo_root/$src" "$dst"
}

copy_release_file "scripts/enhance-scope" "$stage_dir/scripts/enhance-scope"
copy_release_file "scripts/conventional-merge-commit" "$stage_dir/scripts/conventional-merge-commit"
copy_release_file "scripts/lib/commit-msg.sh" "$stage_dir/scripts/lib/commit-msg.sh"
copy_release_file ".pre-commit-hooks.yaml" "$stage_dir/.pre-commit-hooks.yaml"
copy_release_file "README.md" "$stage_dir/README.md"
copy_release_file "LICENSE" "$stage_dir/LICENSE"

# Normalize file metadata for reproducible archives.
fixed_mtime="198001010000"
touch -t "$fixed_mtime" \
	"$stage_dir" \
	"$stage_dir/scripts" \
	"$stage_dir/scripts/lib" \
	"$stage_dir/scripts/enhance-scope" \
	"$stage_dir/scripts/conventional-merge-commit" \
	"$stage_dir/scripts/lib/commit-msg.sh" \
	"$stage_dir/.pre-commit-hooks.yaml" \
	"$stage_dir/README.md" \
	"$stage_dir/LICENSE"

tarball="$out_dir/$bundle_name.tar.gz"
zipfile="$out_dir/$bundle_name.zip"
checksums_file="$out_dir/$bundle_name-checksums.txt"

rm -f "$tarball" "$zipfile" "$checksums_file"

(
	cd "$tmp_dir"
	tar -czf "$tarball" \
		"$bundle_name/.pre-commit-hooks.yaml" \
		"$bundle_name/LICENSE" \
		"$bundle_name/README.md" \
		"$bundle_name/scripts/conventional-merge-commit" \
		"$bundle_name/scripts/enhance-scope" \
		"$bundle_name/scripts/lib/commit-msg.sh"
)

(
	cd "$tmp_dir"
	zip -X -q "$zipfile" \
		"$bundle_name/.pre-commit-hooks.yaml" \
		"$bundle_name/LICENSE" \
		"$bundle_name/README.md" \
		"$bundle_name/scripts/conventional-merge-commit" \
		"$bundle_name/scripts/enhance-scope" \
		"$bundle_name/scripts/lib/commit-msg.sh"
)

sha256_of() {
	file="$1"

	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum "$file" | awk '{print $1}'
	else
		shasum -a 256 "$file" | awk '{print $1}'
	fi
}

{
	hash="$(sha256_of "$tarball")"
	printf '%s  %s\n' "$hash" "$(basename "$tarball")"
	hash="$(sha256_of "$zipfile")"
	printf '%s  %s\n' "$hash" "$(basename "$zipfile")"
} >"$checksums_file"

echo "Built release artifacts:"
echo " - $tarball"
echo " - $zipfile"
echo " - $checksums_file"
