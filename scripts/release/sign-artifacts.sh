#!/bin/sh

set -eu

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
	echo "Usage: $0 <artifacts_dir> [tag]" >&2
	exit 1
fi

artifacts_dir="$1"
tag="${2:-}"

if [ ! -d "$artifacts_dir" ]; then
	echo "Error: artifacts directory not found: $artifacts_dir" >&2
	exit 1
fi

if ! command -v cosign >/dev/null 2>&1; then
	echo "Error: cosign is required for Sigstore signing" >&2
	exit 1
fi

if ! command -v gpg >/dev/null 2>&1; then
	echo "Error: gpg is required for GPG signing" >&2
	exit 1
fi

signed_any=0
for artifact in "$artifacts_dir"/*; do
	if [ ! -f "$artifact" ]; then
		continue
	fi

	case "$artifact" in
	*.asc | *.sig | *.pem) continue ;;
	esac

	echo "Signing $(basename "$artifact") with Sigstore..."
	cosign sign-blob --yes \
		--output-signature "$artifact.sig" \
		--output-certificate "$artifact.pem" \
		"$artifact"

	echo "Signing $(basename "$artifact") with GPG..."
	if [ -n "${GPG_PASSPHRASE-}" ]; then
		printf '%s' "$GPG_PASSPHRASE" | gpg --batch --yes \
			--pinentry-mode loopback \
			--passphrase-fd 0 \
			--armor \
			--detach-sign \
			--output "$artifact.asc" \
			"$artifact"
	else
		gpg --batch --yes \
			--armor \
			--detach-sign \
			--output "$artifact.asc" \
			"$artifact"
	fi

	signed_any=1
done

if [ "$signed_any" -eq 0 ]; then
	echo "Error: no signable artifacts found in $artifacts_dir" >&2
	exit 1
fi

if [ -n "$tag" ]; then
	echo "Completed signing release artifacts for $tag."
else
	echo "Completed signing release artifacts."
fi

echo ""
echo "Verification commands:"
for artifact in "$artifacts_dir"/*; do
	if [ ! -f "$artifact" ]; then
		continue
	fi

	case "$artifact" in
	*.asc | *.sig | *.pem) continue ;;
	esac

	echo " - cosign verify-blob --signature \"$artifact.sig\" --certificate \"$artifact.pem\" --certificate-oidc-issuer https://token.actions.githubusercontent.com --certificate-identity-regexp 'https://github.com/.+' \"$artifact\""
	echo " - gpg --verify \"$artifact.asc\" \"$artifact\""
done
