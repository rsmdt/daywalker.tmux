#!/usr/bin/env bash
# Daywalker Theme - Runtime Theme Switcher
# Usage: switch-theme.sh <dark|light|toggle>
#
# Examples:
#   switch-theme.sh dark     # Switch to dark theme
#   switch-theme.sh light    # Switch to light theme
#   switch-theme.sh toggle   # Toggle between dark and light
#   switch-theme.sh          # Default: toggle

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get requested mode (default: toggle)
mode="${1:-toggle}"

# Handle toggle
if [[ "$mode" == "toggle" ]]; then
    current=$(tmux show-option -gqv "@daywalker_variant")
    if [[ "$current" == "light" ]]; then
        mode="dark"
    else
        mode="light"
    fi
fi

# Validate mode
if [[ "$mode" != "dark" && "$mode" != "light" ]]; then
    echo "Usage: switch-theme.sh <dark|light|toggle>" >&2
    exit 1
fi

# Update stored variant and apply theme
tmux set -g @daywalker_variant "$mode"
"${SCRIPT_DIR}/daywalker.sh" "$mode"
