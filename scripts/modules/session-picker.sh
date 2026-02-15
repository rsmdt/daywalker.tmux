#!/usr/bin/env bash
# Daywalker Theme - Session Picker
# Interactive session switcher for use inside display-popup
# Uses fzf (with preview) when available, falls back to numbered list

set -e

current_session=$(tmux display-message -p '#S')

# Get all sessions except the current one
sessions=$(tmux list-sessions -F '#{session_name}' | grep -v "^${current_session}$" || true)

if [[ -z "$sessions" ]]; then
    echo "No other sessions."
    sleep 1
    exit 0
fi

# Format: "session_name (N windows) [attached]"
format_session() {
    tmux list-sessions -F '#{session_name}|#{session_windows}|#{?session_attached,attached,}' \
        | grep -v "^${current_session}|"
}

pick_with_fzf() {
    local selected
    selected=$(echo "$sessions" | fzf \
        --reverse \
        --no-info \
        --header="  ${current_session} (current)" \
        --prompt="> " \
        --border=none \
        --preview='tmux capture-pane -e -p -t {}:' \
        --preview-window='right:60%:wrap' \
        --preview-label=' Preview ')
    echo "$selected"
}

pick_with_menu() {
    local i=1
    local session_array=()

    echo "Current: ${current_session}"
    echo ""

    while IFS='|' read -r name windows attached; do
        local suffix=""
        [[ -n "$attached" ]] && suffix=" (attached)"
        echo "  ${i}) ${name}  ${windows} windows${suffix}"
        session_array+=("$name")
        i=$((i + 1))
    done < <(format_session)

    if [[ ${#session_array[@]} -eq 0 ]]; then
        echo "No other sessions."
        sleep 1
        return
    fi

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
