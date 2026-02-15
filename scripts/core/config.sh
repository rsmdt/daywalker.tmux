#!/usr/bin/env bash
# Daywalker Theme - Configuration Loading
# Loads all user configuration options with defaults

# Prevent double-sourcing
[[ -n "$DAYWALKER_CONFIG_LOADED" ]] && return 0
export DAYWALKER_CONFIG_LOADED=1

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Session Configuration
# └─────────────────────────────────────────────────────────────────────────────
session_icon=$(get_tmux_option "@daywalker_session_icon" "󰆧")
show_session_dots=$(get_tmux_option "@daywalker_show_session_dots" "true")

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Window Configuration
# └─────────────────────────────────────────────────────────────────────────────
window_separator=$(get_tmux_option "@daywalker_window_separator" "|")
window_number=$(get_tmux_option "@daywalker_show_window_number" "true")
window_position=$(get_tmux_option "@daywalker_window_position" "right")

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Status Modules Configuration
# └─────────────────────────────────────────────────────────────────────────────
# Comma-separated module lists: "mode,session,datetime,git,battery,host,user"
status_left_modules=$(get_tmux_option "@daywalker_status_left" "mode,session")
status_right_modules=$(get_tmux_option "@daywalker_status_right" "")

# ┌─────────────────────────────────────────────────────────────────────────────
# │ DateTime Configuration
# └─────────────────────────────────────────────────────────────────────────────
date_format=$(get_tmux_option "@daywalker_date_format" "%Y-%m-%d")
time_format=$(get_tmux_option "@daywalker_time_format" "%H:%M")

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Export for use in other scripts
# └─────────────────────────────────────────────────────────────────────────────
export session_icon show_session_dots
export window_separator window_number window_position
export status_left_modules status_right_modules
export date_format time_format

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Menu Configuration
# └─────────────────────────────────────────────────────────────────────────────
menu_enabled=$(get_tmux_option "@daywalker_menu" "true")
menu_key=$(get_tmux_option "@daywalker_menu_key" "M-Up")
menu_title=$(get_tmux_option "@daywalker_menu_title" " Menu ")
menu_click_enabled=$(get_tmux_option "@daywalker_menu_click" "true")
menu_icon=$(get_tmux_option "@daywalker_menu_icon" "☰")

export menu_enabled menu_key menu_title menu_click_enabled menu_icon
