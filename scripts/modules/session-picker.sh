#!/usr/bin/env bash
# Daywalker Theme - Session Picker
# Interactive session switcher for use inside display-popup
# Uses fzf (with preview) when available, falls back to numbered list

set -e

current_session=$(tmux display-message -p '#S')

# List all sessions, marking the current one
# Used by fzf bindings after mutations to reload the list
RELOAD_CMD="tmux list-sessions -F '#{session_name}' | sed 's/^${current_session}\$/${current_session} (current)/'"

sessions=$(eval "$RELOAD_CMD" || true)

if [[ -z "$sessions" ]]; then
    echo "No sessions."
    sleep 1
    exit 0
fi

# Format: "session_name (N windows) [attached]"
format_session() {
    tmux list-sessions -F '#{session_name}|#{session_windows}|#{?session_attached,attached,}'
}

# shellcheck disable=SC2016
pick_with_fzf() {
    local selected
    selected=$(echo "$sessions" | fzf \
        --reverse \
        --no-info \
        --header='? for help' \
        --prompt="> " \
        --border=none \
        --delimiter=' ' \
        --preview='tmux capture-pane -e -p -t {1}:' \
        --preview-window='right:60%:wrap' \
        --preview-label=' Preview ' \
        --bind='?:change-header(ctrl-x kill · ctrl-n new · ctrl-r rename)' \
        --bind="ctrl-x:execute-silent(tmux kill-session -t {1})+reload(${RELOAD_CMD})" \
        --bind="ctrl-n:execute-silent(tmux new-session -d)+reload(${RELOAD_CMD})" \
        --bind='ctrl-r:execute(printf "New name: " && read -r name && [ -n "$name" ] && tmux rename-session -t {1} "$name")+reload('"${RELOAD_CMD}"')')
    echo "${selected%% (current)}"
}

pick_with_menu() {
    local i=1
    local session_array=()

    while IFS='|' read -r name windows attached; do
        local suffix=""
        [[ "$name" == "$current_session" ]] && suffix=" (current)"
        [[ -n "$attached" ]] && suffix+=" [attached]"
        echo "  ${i}) ${name}  ${windows} windows${suffix}"
        session_array+=("$name")
        i=$((i + 1))
    done < <(format_session)

    if [[ ${#session_array[@]} -eq 0 ]]; then
        echo "No sessions."
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
