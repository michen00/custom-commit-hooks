.ONESHELL:

DEBUG    ?= false
VERBOSE  ?= false

ifeq ($(DEBUG),true)
    MAKEFLAGS += --debug=v
else ifneq ($(VERBOSE),true)
    MAKEFLAGS += --silent
endif

PRECOMMIT ?= pre-commit
ifneq ($(shell command -v prek >/dev/null 2>&1 && echo y),)
    PRECOMMIT := prek
    ifneq ($(filter true,$(DEBUG) $(VERBOSE)),)
        $(info Using prek for pre-commit checks)
        ifeq ($(DEBUG),true)
            PRECOMMIT := $(PRECOMMIT) -v
        endif
    endif
endif

# Terminal formatting (tput with fallbacks to ANSI codes)
_COLOR  := $(shell tput sgr0 2>/dev/null || printf '\033[0m')
BOLD    := $(shell tput bold 2>/dev/null || printf '\033[1m')
CYAN    := $(shell tput setaf 6 2>/dev/null || printf '\033[0;36m')
GREEN   := $(shell tput setaf 2 2>/dev/null || printf '\033[0;32m')
RED     := $(shell tput setaf 1 2>/dev/null || printf '\033[0;31m')
YELLOW  := $(shell tput setaf 3 2>/dev/null || printf '\033[0;33m')

.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help message
	@echo "$(BOLD)Available targets:$(_COLOR)"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
        awk 'BEGIN {FS = ":.*?## "; max = 0} \
            {if (length($$1) > max) max = length($$1)} \
            {targets[NR] = $$0} \
            END {for (i = 1; i <= NR; i++) { \
                split(targets[i], arr, FS); \
                printf "$(CYAN)%-*s$(_COLOR) %s\n", max + 2, arr[1], arr[2]}}'
	@echo
	@echo "$(BOLD)Environment variables:$(_COLOR)"
	@echo "  $(YELLOW)DEBUG$(_COLOR) = true|false    Set to true to enable debug output (default: false)"
	@echo "  $(YELLOW)VERBOSE$(_COLOR) = true|false  Set to true to enable verbose output (default: false)"

.PHONY: develop
WITH_HOOKS ?= true
WITH_SYNC_MAIN ?= false
develop: ## Set up the project for development (WITH_HOOKS={true|false}, WITH_SYNC_MAIN={true|false}, default=true/false)
	@git config --local blame.ignoreRevsFile .git-blame-ignore-revs
	@if command -v git-lfs >/dev/null 2>&1; then \
        git lfs install --local --skip-repo || true; \
    fi
	@if [ "$(WITH_SYNC_MAIN)" = "true" ]; then \
        $(MAKE) sync-main; \
    fi
	@if [ "$(WITH_HOOKS)" = "true" ]; then \
        $(MAKE) enable-pre-commit; \
    fi

.PHONY: sync-main
sync-main: ## Sync local branch with latest main
	@set -e; \
    current_branch=$$(git branch --show-current); \
    stash_was_needed=0; \
    cleanup() { \
        exit_code=$$?; \
        if [ "$$current_branch" != "$$(git branch --show-current)" ]; then \
            echo "$(YELLOW)Warning: Still on $$(git branch --show-current). Attempting to return to $$current_branch...$(_COLOR)"; \
            if git switch "$$current_branch" 2>/dev/null; then \
                echo "Successfully returned to $$current_branch"; \
            else \
                echo "$(YELLOW)Could not return to $$current_branch. You are on $$(git branch --show-current).$(_COLOR)"; \
            fi; \
        fi; \
        if [ $$stash_was_needed -eq 1 ] && git stash list | head -1 | grep -q "Auto stash by make develop"; then \
            echo "$(YELLOW)Note: Your stashed changes are still available. Run 'git stash pop' to restore them.$(_COLOR)"; \
        fi; \
        exit $$exit_code; \
    }; \
    trap cleanup EXIT; \
    if ! git diff --quiet || ! git diff --cached --quiet; then \
        git stash push -m "Auto stash by make develop"; \
        stash_was_needed=1; \
    fi; \
    git switch main && git pull; \
    if command -v git-lfs >/dev/null 2>&1; then \
        git lfs pull || true; \
    fi; \
    git switch "$$current_branch"; \
    if [ $$stash_was_needed -eq 1 ]; then \
        if git stash apply; then \
            git stash drop; \
        else \
            echo "$(RED)Error: Stash apply had conflicts. Resolve them, then run: git stash drop$(_COLOR)"; \
        fi; \
    fi; \
    trap - EXIT

.PHONY: test-hooks
test-hooks: ## Run hook unit tests
	@bash tests/test-unit.sh

.PHONY: test-integration
test-integration: ## Run pre-commit integration tests
	@bash tests/test-integration.sh

.PHONY: test
test: test-hooks test-integration ## Run all tests

.PHONY: check
check: run-pre-commit test ## Run all code quality checks and tests

.PHONY: benchmark
benchmark: ## Run all benchmark scripts (see scripts/benchmark/run.sh --list)
	@sh scripts/benchmark/run.sh

.PHONY: release-pr
release-pr: ## Trigger Release PR workflow (usage: make release-pr [VERSION=1.2.3]; omit to infer)
	@if [ -n "$(VERSION)" ]; then \
        gh workflow run release-pr.yml --ref main -f version=$(VERSION); \
    else \
        echo "No VERSION given; inferring from conventional commits."; \
        gh workflow run release-pr.yml --ref main; \
    fi

.PHONY: release-pr-watch
release-pr-watch: ## Watch the latest workflow run (run after make release-pr)
	@gh run watch

.PHONY: release-status
release-status: ## Show latest release, any open release PR, and any run awaiting approval
	@sh scripts/release/approve.sh --status

.PHONY: release-approve
release-approve: ## Approve the waiting release (usage: make release-approve [YES=1] to skip the prompt)
	@if [ -n "$(YES)" ]; then \
        sh scripts/release/approve.sh --yes; \
    else \
        sh scripts/release/approve.sh; \
    fi

# pre-commit refuses to install when core.hooksPath is set, even when the
# value points at the default .git/hooks (the same path it would write to
# anyway). A previous tool can stamp this no-op value into a fresh clone's
# local config. Auto-unset only that default so we don't quietly disrupt a
# real third-party hooks framework (husky, lefthook, ...).
.PHONY: enable-pre-commit
enable-pre-commit: ## Enable pre-commit hooks (along with commit-msg and pre-push hooks)
	@hookspath="$$(git config --local --get core.hooksPath 2>/dev/null || true)"; \
    common_hooks_dir="$$(git rev-parse --git-common-dir 2>/dev/null)/hooks"; \
    if [ -n "$$hookspath" ]; then \
        case "$$hookspath" in \
            .git/hooks|"$$common_hooks_dir") \
                echo "$(YELLOW)Note: unsetting local core.hooksPath='$$hookspath' (default value) so pre-commit can install.$(_COLOR)"; \
                git config --local --unset-all core.hooksPath || true; \
                ;; \
            *) \
                echo "$(BOLD)$(RED)Error: core.hooksPath is set to '$$hookspath' (non-default).$(_COLOR)" >&2; \
                echo "       pre-commit refuses to install over an explicit core.hooksPath." >&2; \
                echo "       Either point your other hook framework elsewhere, or run" >&2; \
                echo "       'git config --local --unset-all core.hooksPath' before retrying." >&2; \
                echo "       Alternatively, run 'make develop WITH_HOOKS=false' to skip hook installation." >&2; \
                exit 1; \
                ;; \
        esac; \
    fi; \
    if command -v pre-commit >/dev/null 2>&1; then \
        pre-commit install --hook-type commit-msg --hook-type pre-commit --hook-type pre-push --hook-type prepare-commit-msg ; \
    else \
        echo "$(YELLOW)Warning: pre-commit is not installed. Skipping hook installation.$(_COLOR)"; \
        echo "Install it with: pip install pre-commit (or brew install pre-commit on macOS)"; \
    fi

.PHONY: run-pre-commit
run-pre-commit: ## Run the pre-commit checks
	$(PRECOMMIT) run --all-files
