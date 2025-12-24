.ONESHELL:
.WAIT:

DEBUG    ?= false
VERBOSE  ?= false

ifeq ($(DEBUG),true)
    MAKEFLAGS += --debug=v
else ifeq ($(VERBOSE),false)
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
_COLOR  := $(shell tput sgr0 2>/dev/null || echo "\033[0m")
BOLD    := $(shell tput bold 2>/dev/null || echo "\033[1m")
CYAN    := $(shell tput setaf 6 2>/dev/null || echo "\033[0;36m")
GREEN   := $(shell tput setaf 2 2>/dev/null || echo "\033[0;32m")
RED     := $(shell tput setaf 1 2>/dev/null || echo "\033[0;31m")
YELLOW  := $(shell tput setaf 3 2>/dev/null || echo "\033[0;33m")

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
develop: ## Set up the project for development (WITH_HOOKS={true|false}, default=true)
	@git config blame.ignoreRevsFile .git-blame-ignore-revs
	@git lfs install --local; \
       current_branch=$$(git branch --show-current) && \
       if ! git diff --quiet || ! git diff --cached --quiet; then \
           git stash push -m "Auto stash before switching to main"; \
           stash_was_needed=1; \
       else \
           stash_was_needed=0; \
       fi; \
       git switch main && git pull && \
       git lfs pull && git switch $$current_branch; \
       if [ $$stash_was_needed -eq 1 ]; then \
           git stash pop; \
       fi
	@if [ "$(WITH_HOOKS)" = "true" ]; then \
        $(MAKE) enable-pre-commit; \
    fi

.PHONY: test
test: ## Run all tests
	@bash tests/test-runner.sh

.PHONY: check
check: run-pre-commit test ## Run all code quality checks and tests

.PHONY: run-pre-commit
run-pre-commit: ## Run the pre-commit checks
	$(PRECOMMIT) run --all-files

.PHONY: enable-pre-commit
enable-pre-commit: ## Enable pre-commit hooks (along with commit-msg and pre-push hooks)
	@pre-commit install --hook-type commit-msg --hook-type pre-commit --hook-type pre-push
