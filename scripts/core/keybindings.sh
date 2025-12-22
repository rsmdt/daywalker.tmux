#!/usr/bin/env bash
# Daywalker Theme - Keybindings
# Configurable vim-style keybindings for tmux

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Keybinding Configuration
# └─────────────────────────────────────────────────────────────────────────────

apply_keybindings() {
    local enable_keybindings
    enable_keybindings=$(get_tmux_option "@daywalker_keybindings" "true")

    if [[ "$enable_keybindings" != "true" ]]; then
        return 0
    fi

    # ┌─────────────────────────────────────────────────────────────────────────
    # │ Vim-style Pane Splitting (prefix + h/j/k/l)
    # └─────────────────────────────────────────────────────────────────────────
    local split_left split_right split_up split_down
    split_left=$(get_tmux_option "@daywalker_key_split_left" "h")
    split_right=$(get_tmux_option "@daywalker_key_split_right" "l")
    split_up=$(get_tmux_option "@daywalker_key_split_up" "k")
    split_down=$(get_tmux_option "@daywalker_key_split_down" "j")

    tmux bind-key "$split_right" split-window -h  -c "#{pane_current_path}"
    tmux bind-key "$split_left"  split-window -hb -c "#{pane_current_path}"
    tmux bind-key "$split_down"  split-window -v  -c "#{pane_current_path}"
    tmux bind-key "$split_up"    split-window -vb -c "#{pane_current_path}"

    # ┌─────────────────────────────────────────────────────────────────────────
    # │ Window Navigation (Alt + key, no prefix)
    # └─────────────────────────────────────────────────────────────────────────
    local prev_window next_window swap_left swap_right
    prev_window=$(get_tmux_option "@daywalker_key_prev_window" "M-h")
    next_window=$(get_tmux_option "@daywalker_key_next_window" "M-l")
    swap_left=$(get_tmux_option "@daywalker_key_swap_window_left" "S-M-Left")
    swap_right=$(get_tmux_option "@daywalker_key_swap_window_right" "S-M-Right")

    tmux bind-key -n "$prev_window" previous-window
    tmux bind-key -n "$next_window" next-window
    tmux bind-key -n M-Left previous-window
    tmux bind-key -n M-Right next-window
    tmux bind-key -n "$swap_left" run "tmux swap-window -d -t #{e|-|:#I,1}"
    tmux bind-key -n "$swap_right" run "tmux swap-window -d -t #{e|+|:#I,1}"

    # ┌─────────────────────────────────────────────────────────────────────────
    # │ Quick Actions (Alt + key, no prefix)
    # └─────────────────────────────────────────────────────────────────────────
    local kill_pane choose_tree new_window new_session
    kill_pane=$(get_tmux_option "@daywalker_key_kill_pane" "M-x")
    choose_tree=$(get_tmux_option "@daywalker_key_choose_tree" "M-s")
    new_window=$(get_tmux_option "@daywalker_key_new_window" "M-c")
    new_session=$(get_tmux_option "@daywalker_key_new_session" "M-n")

    tmux bind-key -n "$kill_pane" kill-pane
    tmux bind-key -n "$choose_tree" choose-tree
    tmux bind-key -n "$new_window" new-window -c "#{pane_current_path}"
    tmux bind-key -n "$new_session" new-session

    # Also bind with prefix for convenience
    tmux bind-key x kill-pane
    tmux bind-key s choose-tree
    tmux bind-key c new-window -c "#{pane_current_path}"
}
