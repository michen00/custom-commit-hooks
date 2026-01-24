# custom-commit-hooks

[![Build Status](https://img.shields.io/github/actions/workflow/status/michen00/custom-commit-hooks/CI.yml?style=plastic)](https://github.com/michen00/custom-commit-hooks/actions)
[![Coverage](https://img.shields.io/codecov/c/github/michen00/custom-commit-hooks?style=plastic)](https://codecov.io/gh/michen00/custom-commit-hooks)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=plastic)](CONTRIBUTING.md)
[![License](https://img.shields.io/github/license/michen00/custom-commit-hooks?style=plastic)](LICENSE)

<!-- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.YOUR_ZENODO_ID.svg?style=plastic)](https://doi.org/10.5281/zenodo.YOUR_ZENODO_ID) -->

Custom commit hooks for use with [pre-commit](https://pre-commit.com/) that enhance conventional commit messages with better context and consistency.

## Features

- 🎯 **Automatic scope enhancement** - Add filenames as scopes to single-file commits
- 🔀 **Conventional merge commits** - Transform merge commits to follow conventional commit format
- ⚡ **Zero configuration** - Works out of the box with sensible defaults
- 📏 **Smart formatting** - Respects commit message length limits (50 character summary)

## Installation

### Prerequisites

- [pre-commit](https://pre-commit.com/) installed in your repository
- Git repository following [Conventional Commits](https://www.conventionalcommits.org/) format

### Setup

Add the following to your `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/michen00/custom-commit-hooks
    rev: v0.0.4 # Use the latest version
    hooks:
      - id: enhance-scope
      - id: conventional-merge-commit
```

Then install the hooks:

```bash
pre-commit install --hook-type commit-msg --hook-type prepare-commit-msg
```

## Hooks

### [enhance-scope](scripts/enhance-scope)

Automatically adds the filename as the scope to conventional commit messages for single-file commits, improving commit history readability.

When you commit changes to a single file with a conventional commit message that lacks a scope, this hook automatically adds the filename as the scope.

#### Trigger conditions

The hook only modifies commits when **all** of the following conditions are met:

- ✅ Exactly **one file** is being committed
- ✅ Commit message follows **conventional commit format** (e.g., `feat:`, `fix:`, `docs:`, etc.)
- ✅ **No pre-existing scope** in the commit message
- ✅ The filename **doesn't already appear** in the commit summary
- ✅ Adding the filename scope keeps the summary **under 50 characters**

**Before:**

```commit-message-summary
build: add a dependency
```

**After:**

```commit-message-summary
build(pyproject.toml): add a dependency
```

### [conventional-merge-commit](scripts/conventional-merge-commit)

Transforms Git's default merge commit messages to follow conventional commit format.

Git's default merge commit summaries begin with `Merge ...`, which doesn't conform to conventional commit format. This hook automatically prefixes merge commits with `chore: merge ...` instead.

**Before:**

```commit-message-summary
Merge branch 'feature/new-api' into main
```

**After:**

```commit-message-summary
chore: merge branch 'feature/new-api' into main
```

## Documentation: [![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/michen00/custom-commit-hooks)
