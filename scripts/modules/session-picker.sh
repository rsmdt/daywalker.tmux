#!/usr/bin/env bash
# Daywalker Theme - Session Picker
# Interactive session switcher for use inside display-popup
# Uses fzf when available, falls back to numbered list

set -e

current_session=$(tmux display-message -p '#S')

# Get all sessions except the current one
sessions=$(tmux list-sessions -F '#{session_name}' | grep -v "^${current_session}$" || true)

if [[ -z "$sessions" ]]; then
    echo "No other sessions."
    sleep 1
    exit 0
fi

pick_with_fzf() {
    local selected
    selected=$(echo "$sessions" | fzf \
        --reverse \
        --no-info \
        --header="Current: ${current_session}" \
        --prompt="Switch to: " \
        --border=none)
    echo "$selected"
}

pick_with_menu() {
    local i=1
    local session_array=()

    echo "Current: ${current_session}"
    echo ""

    while IFS= read -r s; do
        echo "  ${i}) ${s}"
        session_array+=("$s")
        i=$((i + 1))
    done <<< "$sessions"

    echo ""
    read -r -p "Switch to [1-$((i - 1))]: " choice

    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice < i )); then
        echo "${session_array[$((choice - 1))]}"
    fi
}

# Pick a session — fzf if available, numbered list otherwise
if command -v fzf &>/dev/null; then
    target=$(pick_with_fzf)
else
    target=$(pick_with_menu)
fi

if [[ -n "$target" ]]; then
    tmux switch-client -t "$target"
fi
