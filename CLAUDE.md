# Project Memory

Custom commit hooks for use with [pre-commit](https://pre-commit.com/) that enhance conventional commit messages with better context and consistency.

## Development Commands

- Install pre-commit hooks: `pre-commit install --hook-type commit-msg --hook-type prepare-commit-msg`
- Run tests: `tests/test-runner.sh` or `make test`
- Lint shell scripts: `find scripts -type f -exec shellcheck --shell=sh {} +`
- Format YAML: Check YAML syntax with your editor or `yamllint .pre-commit-config.yaml`
- Generate changelog: `git cliff --tag <version> --output CHANGELOG.md`

See @README.md for project overview and features.

## Project Structure

- `scripts/enhance-scope` - Shell script hook that adds filename as scope for single-file commits
- `scripts/conventional-merge-commit` - Shell script hook that transforms merge commits to conventional format
- `.pre-commit-hooks.yaml` - Hook definitions for pre-commit framework
- `cliff.toml` - Configuration for git-cliff changelog generation
- `tests/` - Test files (if present)

## Code Style

- **Shell scripts**: Use POSIX-compliant shell scripting (scripts use `#!/bin/sh` and avoid bash-specific features)
- **Error handling**: Include proper exit codes (0 for success, non-zero for errors)
- **Length limits**: Keep commit summaries under 50 characters
- **Conventional commits**: Follow [Conventional Commits](https://www.conventionalcommits.org/) format
- **Indentation**: Match existing patterns in each file

## Git Workflow

- Use conventional commit format: `type(scope): description`
- Reference git-cliff configuration in @cliff.toml when writing commits
- Common types: `feat`, `fix`, `docs`, `chore`, `test`, `refactor`
- Merge commits should be prefixed with `chore: merge`
- Keep commit messages clear and descriptive

## Testing Requirements

- Test hooks with actual git operations before committing
- Verify hooks work with pre-commit framework
- Test edge cases: empty commits, multi-file commits, commits with existing scopes
- Ensure hooks don't break normal git workflows

## Architectural Patterns

- Hooks should be idempotent - running multiple times produces same result
- Hooks should fail gracefully - exit with non-zero code on errors
- Parse commit messages carefully to avoid breaking valid formats
- Only modify commits when specific conditions are met

## Boundaries

**Always do:**

- Read existing hook scripts before modifying them
- Test hook changes with actual git commits
- Maintain POSIX compatibility for shell scripts
- Keep commit summaries under 50 characters
- Follow conventional commit format

**Ask first:**

- Changing hook behavior or trigger conditions
- Modifying the pre-commit hook configuration
- Adding new dependencies or requirements
- Changing the commit message format conventions

**Never do:**

- Break existing conventional commit messages
- Make hooks that are not idempotent
- Add complex dependencies (keep hooks lightweight)
- Ignore shell script exit codes
- Modify commits that already follow conventions
