#!/usr/bin/env bash
# Daywalker Theme - Apply Settings
# Applies all tmux configuration settings

# Prevent double-sourcing
[[ -n "$DAYWALKER_APPLY_LOADED" ]] && return 0
export DAYWALKER_APPLY_LOADED=1

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Apply Theme
# └─────────────────────────────────────────────────────────────────────────────
apply_theme() {
    # Build formats
    local window_format_inactive
    local window_format_current
    local status_left
    local status_right

    window_format_inactive=$(build_window_format_inactive)
    window_format_current=$(build_window_format_current)
    status_left=$(build_status_left)
    status_right=$(build_status_right)

    # ┌─────────────────────────────────────────────────────────────────────────
    # │ Status Bar
    # └─────────────────────────────────────────────────────────────────────────
    tmux set -g status-style "fg=${fg},bg=${bg}"
    tmux set -g status-left-length 100
    tmux set -g status-right-length 100
    tmux set -g status-justify right

    # ┌─────────────────────────────────────────────────────────────────────────
    # │ Status Left & Right
    # └─────────────────────────────────────────────────────────────────────────
    tmux set -g status-left "$status_left"
    tmux set -g status-right "$status_right"

    # ┌─────────────────────────────────────────────────────────────────────────
    # │ Window List
    # └─────────────────────────────────────────────────────────────────────────
    tmux set -g window-status-separator " "

    # Inactive windows (shows bell/activity indicators)
    tmux set -g window-status-style "fg=${fg_muted},bg=${bg}"
    tmux set -g window-status-format "$window_format_inactive"

    # Active window (highlighted with background)
    tmux set -g window-status-current-style "fg=${contrast},bg=${accent},bold"
    tmux set -g window-status-current-format "$window_format_current"

    # Enable activity/bell monitoring
    tmux set -g monitor-activity on
    tmux set -g monitor-bell on
    tmux set -g activity-action other
    tmux set -g bell-action other
    tmux set -g visual-activity off
    tmux set -g visual-bell off

    # Bell and activity
    tmux set -g window-status-bell-style "fg=${bg},bg=${warning},bold"
    tmux set -g window-status-activity-style "fg=${bg},bg=${primary}"

    # ┌─────────────────────────────────────────────────────────────────────────
    # │ Messages & Mode
    # └─────────────────────────────────────────────────────────────────────────
    tmux set -g message-style "fg=${contrast},bg=${success}"
    tmux set -g message-command-style "fg=${contrast},bg=${success}"
    tmux set -g mode-style "fg=${contrast},bg=${primary}"

    # ┌─────────────────────────────────────────────────────────────────────────
    # │ Pane Borders
    # └─────────────────────────────────────────────────────────────────────────
    tmux set -g pane-border-style "fg=${border}"
    tmux set -g pane-active-border-style "fg=${accent}"

    # ┌─────────────────────────────────────────────────────────────────────────
    # │ Keybindings & Menu
    # └─────────────────────────────────────────────────────────────────────────
    apply_keybindings
    apply_menu
    apply_menu_click

    # ┌─────────────────────────────────────────────────────────────────────────
    # │ Expose Color Variables
    # └─────────────────────────────────────────────────────────────────────────
    # Users can reference these in their own config: #{@daywalker_color_*}
    tmux set -gq @daywalker_color_bg "$bg"
    tmux set -gq @daywalker_color_fg "$fg"
    tmux set -gq @daywalker_color_fg_muted "$fg_muted"
    tmux set -gq @daywalker_color_primary "$primary"
    tmux set -gq @daywalker_color_accent "$accent"
    tmux set -gq @daywalker_color_warning "$warning"
    tmux set -gq @daywalker_color_success "$success"
    tmux set -gq @daywalker_color_border "$border"
    tmux set -gq @daywalker_color_contrast "$contrast"
}
