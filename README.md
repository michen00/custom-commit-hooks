# custom-commit-hooks

custom commit hooks for use with pre-commit

## Usage

Add the following to your `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/michen00/custom-commit-hooks
    rev: v0.0.0  # Use the latest version
    hooks:
      - id: enhance-scope
      - id: conventional-merge-commit
```

## Hooks

### [enhance-scope](enhance-scope)

Some commits only touch a single file. This hook will add the filename as the scope to conventional commit messages that don't already have a scope, which can improve the readability of a branch's commit history.

Trigger conditions:

- only one file
- conventional commit message format
- no pre-existing scope in the commit message
- the commit summary does not already contain the filename
- adding the filename to the summary would not exceed 50 characters

Instead of `build: add a dependency`, it might become `build(pyproject.toml): add a dependency`.

### [conventional-merge-commit](conventional-merge-commit)

The default merge commit summary typically begins with `Merge ...`, which does not conform to the conventional commit message format. This hook will modify the summary to begin with `chore: merge ...`.
