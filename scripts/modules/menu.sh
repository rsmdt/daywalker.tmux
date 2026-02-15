#!/usr/bin/env bash
# Daywalker Theme - Menu Module
# Clickable menu icon for the status bar

# shellcheck disable=SC2154
# Variables are sourced from themes/*.sh and config.sh

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Setup Mouse Click Binding for Menu
# │ Binds right-click on status bar to open menu
# └─────────────────────────────────────────────────────────────────────────────
apply_menu_click() {
    if [[ "$menu_click_enabled" != "true" ]]; then
        # Clean up any previous mouse binding
        tmux unbind-key -n MouseUp3Status 2>/dev/null || true
        return 0
    fi

    # Get the menu command
    source "${CORE_DIR}/menu.sh"
    local menu_cmd
    menu_cmd=$(get_menu_command)

    # Bind right-click on status bar to open menu
    tmux bind-key -n MouseUp3Status "$menu_cmd"
}
