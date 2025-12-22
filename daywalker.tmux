#!/usr/bin/env bash
# Daywalker Theme for tmux
# https://github.com/rsmdt/daywalker.tmux
#
# A minimal tmux theme with session dots and automatic dark/light mode switching.

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared helpers
source "${CURRENT_DIR}/utils/helpers.sh"

main() {
    local mode
    mode=$(get_tmux_option "@daywalker_variant" "dark")

    "${CURRENT_DIR}/scripts/daywalker.sh" "$mode"
}

main
