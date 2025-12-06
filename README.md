# custom-commit-hooks
custom commit hooks for use with pre-commit

## Usage

Add the following to your `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/michen00/custom-commit-hooks
    rev: v0.1.0  # Use the latest version
    hooks:
      - id: custom-commit-msg
        stages: [commit-msg]
      - id: custom-prepare-commit-msg
        stages: [prepare-commit-msg]
```

## Hooks

### custom-commit-msg

A custom commit-msg hook.

### custom-prepare-commit-msg

A custom prepare-commit-msg hook that modifies merge commit messages by replacing `M` with `chore: m` in the commit message.
