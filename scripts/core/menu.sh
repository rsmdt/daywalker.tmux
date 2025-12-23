#!/usr/bin/env bash
# Daywalker Theme - Menu
# Configurable popup menu for common tmux operations

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Menu Configuration
# └─────────────────────────────────────────────────────────────────────────────

apply_menu() {
    local enable_menu menu_key menu_title
    enable_menu=$(get_tmux_option "@daywalker_menu" "true")
    menu_key=$(get_tmux_option "@daywalker_menu_key" "M-Up")
    menu_title=$(get_tmux_option "@daywalker_menu_title" " Menu ")

    if [[ "$enable_menu" != "true" ]]; then
        return 0
    fi

    # Build menu command - using heredoc for readability
    local menu_cmd
    menu_cmd=$(cat <<'MENU'
display-menu -T " Menu " -x P -y P \
  " New Window"                      c "new-window" \
  " Rename Window"                   r "command-prompt -p 'Rename Window:' 'rename-window %%'" \
  " Kill Window"                     C "kill-window" \
  "" \
  " New Pane Right"                  l "split-window -h -c '#{pane_current_path}'" \
  " New Pane Left"                   h "split-window -hb -c '#{pane_current_path}'" \
  " New Pane Down"                   j "split-window -v -c '#{pane_current_path}'" \
  " New Pane Up"                     k "split-window -vb -c '#{pane_current_path}'" \
  " Move Pane to New Window"         t "break-pane" \
  " Kill Pane"                       x "kill-pane" \
  "" \
  " New Session"                     n "new-session" \
  " Rename Session"                  R "command-prompt -p 'Rename Session:' 'rename-session %%'" \
  " Choose Session"                  s "choose-session" \
  " Kill Other Session(s)"           X "kill-session -a" \
  " Kill Session"                    Q "kill-session" \
  "" \
  " Show Keybindings"                ? "list-keys -N" \
  "Close menu"                        q ""
MENU
)

    # Update title in command
    menu_cmd="${menu_cmd/ Menu /$menu_title}"

    # Bind menu to key
    tmux bind-key -n "$menu_key" "$menu_cmd"
}

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Get Menu Command for Status Bar Click
# │ Returns the menu command for use in mouse bindings
# └─────────────────────────────────────────────────────────────────────────────
get_menu_command() {
    local menu_title
    menu_title=$(get_tmux_option "@daywalker_menu_title" " Menu ")

    # -x 0: left edge, -y S: below status bar
    echo "display-menu -T '$menu_title' -x 0 -y S \
  ' New Window'                      c 'new-window' \
  ' Rename Window'                   r \"command-prompt -p 'Rename Window:' 'rename-window %%'\" \
  ' Kill Window'                     C 'kill-window' \
  '' \
  ' New Pane Right'                  l \"split-window -h -c '#{pane_current_path}'\" \
  ' New Pane Left'                   h \"split-window -hb -c '#{pane_current_path}'\" \
  ' New Pane Down'                   j \"split-window -v -c '#{pane_current_path}'\" \
  ' New Pane Up'                     k \"split-window -vb -c '#{pane_current_path}'\" \
  ' Move Pane to New Window'         t 'break-pane' \
  ' Kill Pane'                       x 'kill-pane' \
  '' \
  ' New Session'                     n 'new-session' \
  ' Rename Session'                  R \"command-prompt -p 'Rename Session:' 'rename-session %%'\" \
  ' Choose Session'                  s 'choose-session' \
  ' Kill Other Session(s)'           X 'kill-session -a' \
  ' Kill Session'                    Q 'kill-session' \
  '' \
  ' Show Keybindings'                ? 'list-keys -N' \
  'Close menu'                        q ''"
}
