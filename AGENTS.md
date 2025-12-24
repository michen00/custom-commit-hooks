# AGENTS.md

A briefing packet for AI coding agents working with this repository.

## What This Is

Custom commit hooks for [pre-commit](https://pre-commit.com/) that enhance conventional commit messages. Two main hooks: `enhance-scope` (adds filename as scope for single-file commits) and `conventional-merge-commit` (transforms merge commits to conventional format).

## Commands

```bash
# Install hooks locally
pre-commit install --hook-type commit-msg --hook-type prepare-commit-msg

# Test hooks manually
git commit -m "test: sample commit"

# Run shellcheck
find scripts -type f -exec shellcheck --shell=sh {} +

# Generate changelog
git cliff --tag v1.0.0 --output CHANGELOG.md
```

## Testing

- Test with actual git commits - this is a hooks project
- Verify single-file commits get scope added: `git add file.py && git commit -m "feat: add thing"`
- Verify merge commits get prefixed: `git merge --no-ff branch`
- Test edge cases: multi-file commits, commits with existing scopes, long filenames
- Ensure hooks exit 0 on success, non-zero on failure

## Project Structure

```tree
scripts/
  enhance-scope                   # Hook: adds filename scope to single-file commits
  conventional-merge-commit       # Hook: transforms merge commits
.pre-commit-hooks.yaml            # Hook definitions
cliff.toml                        # Changelog generation config
README.md                         # User documentation
tests/                            # Test files
```

## Code Style

- POSIX shell scripts - use `#!/bin/sh` and avoid bash-isms like `[[`, `=~`, `BASH_REMATCH`, and `mapfile`
- Exit 0 for success, non-zero for errors
- Keep commit summaries under 50 chars
- Follow <https://www.conventionalcommits.org/>
- Match existing indentation and style in files

## Git Workflow

- Conventional commits: `type(scope): description`
- Types: feat, fix, docs, chore, test, refactor, perf, ci, build, revert
- This repo's commits should follow its own conventions (dogfooding)

## Boundaries

### Always

- Read hook scripts before modifying
- Test with actual git operations
- Keep hooks lightweight and fast
- Exit with proper codes (0/1)
- Maintain POSIX compatibility

### Ask First

- Changing hook trigger conditions
- Modifying commit message format rules
- Adding new hook types
- Changing pre-commit configuration

### Never

- Break conventional commit parsing
- Add heavy dependencies
- Make hooks non-idempotent
- Ignore exit codes or error handling
