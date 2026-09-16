<!-- markdownlint-configure-file { "first-line-heading": false } -->

This PR prepares release `@RELEASE_TAG@`.

## Included

- Stamps `@RELEASE_TAG@` into `CHANGELOG.md` as its own section
- Points the `README.md` install snippet at `@RELEASE_TAG@`
- Validates tests before proposing release prep

The `.pre-commit-config.yaml` self-pin is not touched here — the tag does not exist yet, so pinning it would fail this PR's own checks. The weekly pre-commit autoupdate moves it forward after the tag lands.

Merging this PR creates and pushes the signed tag `@RELEASE_TAG@` and publishes the release. No local tagging step is needed.
