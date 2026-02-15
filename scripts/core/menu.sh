#!/usr/bin/env bash
# Daywalker Theme - Menu
# Configurable popup menu for common tmux operations

# shellcheck disable=SC2154
# Variables are sourced from config.sh

# Prevent double-sourcing
[[ -n "$DAYWALKER_MENU_LOADED" ]] && return 0
export DAYWALKER_MENU_LOADED=1

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Menu Items (single source of truth)
# └─────────────────────────────────────────────────────────────────────────────

# Build the full display-menu command with given position args.
# Usage: _build_menu_command <x_arg> <y_arg>
_build_menu_command() {
    local x_pos="$1" y_pos="$2"

    cat <<MENU
display-menu -T "${menu_title}" -x ${x_pos} -y ${y_pos} \\
  " New Window"                      c "new-window" \\
  " Rename Window"                   r "display-popup -E -T ' Rename Window: #{window_name} ' -w 50 -h 3 '${MODULES_DIR}/rename-popup.sh window'" \\
  " Kill Window"                     C "confirm-before -p 'Kill window #{W}? (y/n)' kill-window" \\
  "" \\
  " New Pane Right"                  l "split-window -h -c '#{pane_current_path}'" \\
  " New Pane Left"                   h "split-window -hb -c '#{pane_current_path}'" \\
  " New Pane Down"                   j "split-window -v -c '#{pane_current_path}'" \\
  " New Pane Up"                     k "split-window -vb -c '#{pane_current_path}'" \\
  " Move Pane to New Window"         t "break-pane" \\
  " Kill Pane"                       x "kill-pane" \\
  "" \\
  " New Session"                     n "new-session" \\
  " Rename Session"                  R "display-popup -E -T ' Rename Session: #S ' -w 50 -h 3 '${MODULES_DIR}/rename-popup.sh session'" \\
  " Choose Session"                  s "display-popup -E -T ' Sessions ' -w 80% -h 80% '${MODULES_DIR}/session-picker.sh'" \\
  " Kill Other Session(s)"           X "confirm-before -p 'Kill all other sessions? (y/n)' 'kill-session -a'" \\
  " Kill Session"                    Q "confirm-before -p 'Kill session #{S}? (y/n)' kill-session" \\
  "" \\
  " Show Keybindings"                ? "list-keys -N" \\
  "Close menu"                        q ""
MENU
}

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Apply Menu Keyboard Binding
# └─────────────────────────────────────────────────────────────────────────────

apply_menu() {
    if [[ "$menu_enabled" != "true" ]]; then
        # Clean up any previous binding
        tmux unbind-key -n "$menu_key" 2>/dev/null || true
        local prev_key
        prev_key=$(tmux show-option -gqv @_daywalker_bound_menu_key 2>/dev/null)
        if [[ -n "$prev_key" ]]; then
            tmux unbind-key -n "$prev_key" 2>/dev/null || true
        fi
        return 0
    fi

    # Clean up previous key if it changed
    local prev_key
    prev_key=$(tmux show-option -gqv @_daywalker_bound_menu_key 2>/dev/null)
    if [[ -n "$prev_key" && "$prev_key" != "$menu_key" ]]; then
        tmux unbind-key -n "$prev_key" 2>/dev/null || true
    fi

    # Bind menu to key (-x 0 -y S: bottom-left, anchored to status bar)
    local menu_cmd
    menu_cmd=$(_build_menu_command "0" "S")
    tmux bind-key -n "$menu_key" "$menu_cmd"

    # Remember the bound key for future cleanup
    tmux set -gq @_daywalker_bound_menu_key "$menu_key"
}

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Get Menu Command for Status Bar Click
# │ Returns the menu command string for use in mouse bindings
# └─────────────────────────────────────────────────────────────────────────────

get_menu_command() {
    # -x 0: left edge, -y S: below status bar
    _build_menu_command "0" "S"
}
