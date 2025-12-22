#!/usr/bin/env bash
# Daywalker Theme - Main Orchestrator
# Usage: daywalker.sh <dark|light>

set -e

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Directory Setup (all relative paths)
# └─────────────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CORE_DIR="${SCRIPT_DIR}/core"
MODULES_DIR="${SCRIPT_DIR}/modules"
THEME_DIR="${ROOT_DIR}/themes"
UTILS_DIR="${ROOT_DIR}/utils"

# Export for use in sourced scripts
export SCRIPT_DIR ROOT_DIR CORE_DIR MODULES_DIR THEME_DIR UTILS_DIR

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Load Shared Helpers
# └─────────────────────────────────────────────────────────────────────────────
source "${UTILS_DIR}/helpers.sh"

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Load Color Palette
# └─────────────────────────────────────────────────────────────────────────────
MODE="${1:-dark}"

if [[ "$MODE" == "light" ]]; then
    source "${THEME_DIR}/light.sh"
else
    source "${THEME_DIR}/dark.sh"
fi

# Default contrast color (dark themes use bg, light themes override)
contrast="${contrast:-$bg}"

# Export colors for use in other scripts
export bg fg fg_muted primary warning accent success border contrast

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Load Core Modules
# └─────────────────────────────────────────────────────────────────────────────
source "${CORE_DIR}/config.sh"
source "${CORE_DIR}/status.sh"
source "${CORE_DIR}/keybindings.sh"
source "${CORE_DIR}/menu.sh"
source "${MODULES_DIR}/menu.sh"
source "${CORE_DIR}/apply.sh"

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Apply Theme
# └─────────────────────────────────────────────────────────────────────────────
apply_theme
