<!-- omit in toc -->

# Releasing

Releases are cut by maintainers. Contributors do not need anything here — see [CONTRIBUTING](CONTRIBUTING.md) instead.

The flow is automated end to end except for a single approval, which is deliberate: that approval is the only thing standing between a merged pull request and a GPG-signed tag minted with the CI release key.

<!-- omit in toc -->

## Table of Contents

- [Default flow](#default-flow)
- [Checking release status](#checking-release-status)
- [Why Release PR sometimes does nothing](#why-release-pr-sometimes-does-nothing)
- [Manual fallback](#manual-fallback)
- [Signing model](#signing-model)
  - [One-time release key setup](#one-time-release-key-setup)
- [Verifying a release](#verifying-a-release)

## Default flow

1. **Release PR** (`.github/workflows/release-pr.yml`) opens the release PR by itself when a commit worth releasing lands on `main`. Every conventional type bumps at least the patch version, so the version cannot decide that on its own; the workflow gates on the group `cliff.toml` parsed each commit into — features, fixes, performance and reverts, plus anything marked breaking. A `chore`, `docs`, `build`, `ci`, `test`, `refactor` or `style` merge — the weekly hook autoupdate and Dependabot among them — rides along in the next release without proposing one. Run the workflow by hand, or `make release-pr`, to pin the version or to release a batch containing none of those types; a manual run skips the worthiness gate. Leave `version` empty to derive it via `git cliff --bumped-version`, or pass `X.Y.Z` / `vX.Y.Z`.
1. Review and merge the generated PR (`chore(release): prepare vX.Y.Z`).
1. **Approve the release.** This is the only manual step, and nothing ships until it happens. Run `make release-approve`, which finds the waiting run, shows the tag it will mint and the commit that tag will point at, and asks you to confirm. You can also approve from the run page on GitHub, or from the PR's checks tab. Rejecting the approval leaves no tag behind.
1. **Release Tag** (`.github/workflows/release-tag.yml`) runs on merge of a `release/*` branch, gated on the protected `release` environment. Once approved it creates a GPG-signed annotated tag, pushes it, and dispatches **Release Publish**.
1. **Release Publish** (`.github/workflows/release-publish.yml`) builds and uploads signed artifacts to the GitHub release.

A release that is never approved simply waits. There is no timeout and no reminder, so a merged release PR can sit indefinitely — `make release-status` is the fastest way to find out whether that is what has happened.

That approval is the only one a normal release needs. **Release Publish** also declares the `release` environment, but when **Release Tag** dispatches it the deployment is created by `github-actions[bot]` and the reviewer rule is skipped, so it proceeds without a second prompt. The declaration still gates a Release Publish run dispatched by hand, which is the manual fallback path. Treat the Release Tag approval as the release decision — no tag means no publish.

## Checking release status

```bash
make release-status   # latest tag, any open release PR, any run awaiting approval
make release-approve  # approve the waiting run after confirming what it will tag
```

Both read the repository through `gh`, so they need an authenticated GitHub CLI and no other local state. `make release-approve` refuses to do anything when no run is waiting, rather than guessing at which run you meant.

## Why Release PR sometimes does nothing

Two guards follow from the tag being what marks a release finished.

**Release PR** refuses to prepare a second release while the last prepared version is still untagged — on a push it says so and stops, and a manual run fails. That covers the approval window: a `fix` merged while **Release Tag** waits would otherwise propose a duplicate PR for the version already on its way out. It also latches when an approval is _rejected_, since that leaves a prepared version that never gets a tag; clear it with the manual fallback below, which both publishes that release and satisfies the check.

And if the version moves while a release PR is open — a `feat` landing on top of a pending patch — the next run opens a PR for the new version and closes the superseded one. **Release Tag** reads the version it mints from the `release/*` branch name, so leaving the stale PR open would leave a merge path that tags the wrong version.

## Manual fallback

1. Tag and push by hand from `main`:
   - `git switch main && git pull`
   - `git tag -a vX.Y.Z -m vX.Y.Z -s`
   - `git push origin vX.Y.Z` A tag pushed this way triggers **Release Publish** directly on tag push.
1. If needed, run **Release Publish** via `workflow_dispatch` with an existing `tag`.

> **Note:** Release Tag dispatches Release Publish explicitly rather than relying on the tag push, because a tag pushed with `GITHUB_TOKEN` does not trigger `on: push: tags`.

## Signing model

- Sigstore keyless signatures are generated in CI for every release artifact.
- GPG detached signatures are also generated for compatibility.
- Release tags are annotated and GPG-signed. When **Release Tag** creates the tag, it is signed with the CI release key rather than a maintainer's personal key. The protected `release` environment is what keeps that key from being usable by anyone who merges a `release/*` PR: the tagging job waits for maintainer approval before it runs.
- Repository secrets for GPG signing in CI:
  - `RELEASE_GPG_PRIVATE_KEY` (ASCII-armored private key) — required.
  - `RELEASE_GPG_PASSPHRASE` (passphrase for that key) — only when the key has one.

This repository's release key has no passphrase, so `RELEASE_GPG_PASSPHRASE` is deliberately absent and `gh secret list` shows only the private key. Both workflows pass the secret through unconditionally and an absent secret expands to an empty string, so `scripts/release/sign-artifacts.sh` — which branches on `[ -n "${GPG_PASSPHRASE-}" ]` — takes its no-passphrase path either way, and the import action accepts an empty passphrase. v0.1.0 through v0.1.2 were all signed that way. Setting the secret to an empty string would sign identically rather than fix anything; it is still not worth creating, because a secret that exists and means nothing invites someone to later fill it with a passphrase the key does not have.

Without the private key, **Release Tag** and **Release Publish** fail at the GPG import step, so no tag is created and no artifacts are published. A GitHub App token does not substitute for it: a token authenticates git and API calls but cannot produce a GPG signature, and GitHub signs only commits it creates via the API, never annotated tag objects.

### One-time release key setup

Run these locally as a maintainer; never paste private key material into an issue, a PR, or a chat transcript.

```bash
# 1. Pick a passphrase and generate a dedicated release key (not your personal key).
PASSPHRASE='<choose-a-strong-passphrase>'
gpg --batch --passphrase "$PASSPHRASE" \
    --quick-generate-key 'custom-commit-hooks release <you@example.com>' rsa4096 sign 2y

# 2. Note the fingerprint of the key you just made.
gpg --list-secret-keys --keyid-format=long

# 3. Export the private key, ASCII-armored.
gpg --armor --export-secret-keys <FINGERPRINT> >release-key.asc

# 4. Store the key on the repository. Set the passphrase secret only if the
#    key has a passphrase -- leave it unset otherwise, rather than empty.
gh secret set RELEASE_GPG_PRIVATE_KEY <release-key.asc
if [ -n "$PASSPHRASE" ]; then
  gh secret set RELEASE_GPG_PASSPHRASE --body "$PASSPHRASE"
fi

# 5. Remove the local export. shred is GNU coreutils and absent on macOS;
#    BSD rm -P is rejected by GNU rm, so branch instead of assuming either.
if command -v shred >/dev/null 2>&1; then
  shred -u release-key.asc
else
  rm -f release-key.asc
fi

# 6. Optional: register the public key so signed tags display as Verified on GitHub.
#    Paste the output at https://github.com/settings/gpg/new
gpg --armor --export <FINGERPRINT>
```

Confirm the secrets landed with `gh secret list`. The key expires in two years; rotate by repeating these steps.

Neither removal above guarantees the bytes are gone: copy-on-write filesystems and SSD wear levelling can leave the export recoverable. Treat the passphrase as the real protection for that file, and prefer a passphrase over an empty one for exactly this reason.

## Verifying a release

```bash
# Sigstore
cosign verify-blob --signature artifact.sig --certificate artifact.pem --certificate-oidc-issuer https://token.actions.githubusercontent.com --certificate-identity-regexp 'https://github.com/.+' artifact

# GPG
gpg --verify artifact.asc artifact
```
