---
description: CI/CD workflow instructions for GitHub Actions
---

# CI/CD Instructions

## Workflows

### CI Workflow (.github/workflows/CI.yml)

**Purpose**: Run code quality checks and tests on every push and PR

**Triggers:**

- Push to main branch
- Pull requests to main
- Manual workflow_dispatch

**Jobs:**

```yaml
ci:
  - Checkout repository
  - Set up Python environment
  - Install and cache pre-commit hooks
  - Run pre-commit hooks (includes shellcheck, yamllint, actionlint, etc.)

test:
  - Checkout repository
  - Set up Git configuration
  - Run test suite (bash test scripts)
```

### Release Workflow (future)

**Triggers:**

- Tags matching `v*.*.*` pattern
- Manual release creation

**Jobs:**

```yaml
release:
  - Generate changelog: git cliff --tag $TAG --output CHANGELOG.md
  - Create GitHub release with changelog
  - Upload hook scripts as release artifacts
```

## Quality Gates

**Required checks before merge:**

- All shellcheck linting passes
- YAML/TOML validation succeeds
- Test suite passes (if exists)
- Commit messages follow conventional format

**Branch protection:**

- Require status checks to pass
- Require branch to be up to date
- Require review for external contributors

## Best Practices

### Performance

- Use caching for dependencies if applicable
- Keep workflows under 5 minutes for fast feedback
- Run shellcheck with `--severity=warning` for balanced strictness

### Security

- Pin action versions: `actions/checkout@v6`, not `@main`
- Use GitHub secrets for any tokens (if needed)
- Limit repository token permissions with `permissions:`

### Reliability

- Fail fast on errors with `set -e` in scripts
- Provide clear error messages in failed checks
- Use matrix strategy only if testing multiple environments

## Commands Reference

```sh
# Validate shell scripts
find scripts -type f -exec shellcheck -e SC2086,SC2181 --shell=sh {} +

# Validate YAML
yamllint .pre-commit-config.yaml .github/workflows/*.yml

# Validate TOML
# Use toml-sort or python -c "import tomli; tomli.load(open('cliff.toml', 'rb'))"

# Run tests (if test framework present)
tests/test-runner.sh

# Generate changelog for release
git cliff --tag v1.0.0 --output CHANGELOG.md
```

## Troubleshooting

**Shellcheck failures:**

- Check the specific SC#### error code
- Review shellcheck wiki: <https://www.shellcheck.net/wiki/>
- Common issues: unquoted variables, command exit codes

**YAML/TOML syntax errors:**

- Validate with online parsers or local tools
- Check indentation (YAML is whitespace-sensitive)
- Ensure proper quoting of strings

**Test failures:**

- Run tests locally to reproduce
- Check git configuration in CI environment
- Verify hook scripts have execute permissions

## Automation Strategy

1. **On every commit**: Run shellcheck + YAML validation
2. **On PR**: Run full test suite, validate commit messages
3. **On tag**: Generate changelog, create release
4. **Scheduled**: Weekly dependency audit (if applicable)

## Monitoring

- Check Actions tab for workflow status
- Set up notifications for failed workflows
- Review and update actions quarterly
- Monitor shellcheck and test coverage trends
