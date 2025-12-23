#!/usr/bin/env bash
# Daywalker Theme - Menu Module
# Clickable menu icon for the status bar

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Menu Module
# │ Displays a clickable menu icon that opens the command menu
# └─────────────────────────────────────────────────────────────────────────────

render_menu() {
    local icon
    icon=$(get_tmux_option "@daywalker_menu_icon" "☰")

    # The menu icon - clicking triggers the menu via mouse binding
    # Mouse binding is set up in apply_menu_click()
    echo "#[fg=${primary}]${icon}#[default]"
}

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Setup Mouse Click Binding for Menu
# │ Binds left-click on status-left/right to open menu at mouse position
# └─────────────────────────────────────────────────────────────────────────────
apply_menu_click() {
    local enable_menu_click
    enable_menu_click=$(get_tmux_option "@daywalker_menu_click" "true")

    if [[ "$enable_menu_click" != "true" ]]; then
        return 0
    fi

    # Get the menu command
    source "${CORE_DIR}/menu.sh"
    local menu_cmd
    menu_cmd=$(get_menu_command)

    # Bind left-click on status-left (mode indicator area) to open menu
    # Using MouseUp so menu persists after release
    tmux bind-key -n MouseUp1StatusLeft "$menu_cmd"

    # Bind right-click anywhere on status bar to open menu
    tmux bind-key -n MouseUp3Status "$menu_cmd"

    # Bind middle-click as well for accessibility
    tmux bind-key -n MouseUp2Status "$menu_cmd"
}
