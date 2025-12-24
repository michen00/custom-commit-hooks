# GitHub Copilot Instructions

## Project Summary

Custom commit hooks for pre-commit that enhance conventional commit messages with automatic scope enhancement and conventional merge commits.

## Tech Stack

- **Shell scripts**: POSIX-compliant shell (`#!/bin/sh`) for hook implementation
- **Pre-commit framework**: Hook management and execution
- **Git hooks**: `commit-msg` and `prepare-commit-msg` stages
- **Git-cliff**: Changelog generation (configured in cliff.toml)
- **Conventional Commits**: Message format specification

## Coding Guidelines

### Shell Scripts (scripts/enhance-scope, scripts/conventional-merge-commit)

- Use POSIX-compliant shell scripting - avoid bash-isms
- Include proper error handling with exit codes (0 = success, non-zero = error)
- Add comments only for complex logic, not obvious operations
- Use consistent variable naming (lowercase with underscores)
- Test all path handling edge cases

### Commit Messages

- Follow conventional commit format: `type(scope): description`
- Types: feat, fix, docs, chore, test, refactor, perf, ci, build, revert
- Keep summaries under 50 characters
- Reference cliff.toml patterns

### Configuration Files

- `.pre-commit-hooks.yaml`: YAML format, validate structure
- `cliff.toml`: TOML format, follows git-cliff schema
- Preserve existing formatting and structure

## Project Structure

- `scripts/enhance-scope` - Adds filename as scope for single-file commits
- `scripts/conventional-merge-commit` - Transforms merge commits to conventional format
- `scripts/lib/` - Shared shell libraries for hooks (including `commit-msg.sh` for commit message handling)
- `.pre-commit-hooks.yaml` - Hook definitions
- `cliff.toml` - Changelog generation config
- `tests/` - Test files
- `README.md` - User documentation

## Common Patterns

### Hook Script Pattern

```bash
#!/bin/sh
# Read commit message
commit_msg_file="$1"
commit_msg=$(cat "$commit_msg_file")

# Check conditions
if [ condition ]; then
    # Transform message
    echo "$new_msg" > "$commit_msg_file"
fi

exit 0
```

### Testing Hooks

```bash
# Run automated test suite
make test
# or
tests/test-runner.sh

# Manual testing: Install hooks and test with actual commits
pre-commit install --hook-type commit-msg --hook-type prepare-commit-msg

# Test enhance-scope: single-file commit gets scope added
git add scripts/enhance-scope
git commit -m "feat: improve hook"
# Result: "feat(scripts/enhance-scope): improve hook"

# Test conventional-merge-commit: merge commit gets transformed
git merge --no-ff feature-branch
# Result: "chore: merge branch 'feature-branch' into main"
```

## Boundaries

**Always:**

- Make hooks idempotent (safe to run multiple times)
- Exit with appropriate codes (0 for success)
- Keep hooks fast and lightweight
- Validate commit message format before modifying

**Ask first:**

- Changes to hook trigger conditions
- Modifications to commit format rules
- Adding new hook types

**Never:**

- Break existing conventional commit messages
- Add heavy dependencies or complex parsing
- Make hooks that modify already-conventional messages unnecessarily
- Use non-POSIX shell features without fallbacks
