#!/usr/bin/env bash
# Shared color definitions for test scripts
# Source this file: source "$(dirname "$0")/colors.sh" or . "$(dirname "$0")/colors.sh"

# ANSI color codes (using 0; prefix for explicit reset)
# shellcheck disable=SC2034 # Variables are exported for use in sourcing scripts
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color (reset)
