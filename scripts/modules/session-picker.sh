#!/usr/bin/env bash
# Daywalker Theme - Session Picker
# Interactive session switcher for use inside display-popup
# Uses fzf (with preview) when available, falls back to numbered list
#
# Subcommands (called by fzf binds):
#   --list           List sessions with (current) marker
#   --kill <name>    Kill session, switching away if current
#   --new            Prompt for name, create session

set -e

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Subcommands (invoked by fzf --bind)
# └─────────────────────────────────────────────────────────────────────────────

_list_sessions() {
    local current
    current=$(tmux display-message -p '#S')
    tmux list-sessions -F '#{session_id}|#{session_name}' \
        | sort -t'|' -k1 -n \
        | cut -d'|' -f2 \
        | sed "s/^${current}\$/${current} (current)/"
}

_kill_session() {
    local target="$1"
    local current
    current=$(tmux display-message -p '#S')

    if [[ "$target" == "$current" ]]; then
        # Switch to another session before killing, otherwise tmux exits
        local other
        other=$(tmux list-sessions -F '#{session_id}|#{session_name}' \
            | sort -t'|' -k1 -n \
            | cut -d'|' -f2 \
            | grep -v "^${target}$" | head -1 || true)
        if [[ -n "$other" ]]; then
            tmux switch-client -t "$other"
            tmux kill-session -t "$target"
        fi
        # If no other session exists, do nothing (don't kill the last session)
    else
        tmux kill-session -t "$target"
    fi
}

_new_session() {
    printf "Session name: "
    read -r name
    if [[ -n "$name" ]]; then
        tmux new-session -d -s "$name"
    else
        tmux new-session -d
    fi
}

# Handle subcommands
case "${1:-}" in
    --list)  _list_sessions; exit 0 ;;
    --kill)  _kill_session "$2"; exit 0 ;;
    --new)   _new_session; exit 0 ;;
esac

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Main Picker
# └─────────────────────────────────────────────────────────────────────────────

sessions=$(_list_sessions)

if [[ -z "$sessions" ]]; then
    echo "No sessions."
    sleep 1
    exit 0
fi

# Format: "session_name|N_windows|attached"
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
        --bind="ctrl-x:execute-silent(${SELF} --kill {1})+reload(${SELF} --list)" \
        --bind="ctrl-n:execute(${SELF} --new)+reload(${SELF} --list)" \
        --bind="ctrl-r:execute(${SELF%/*}/rename-popup.sh session {1})+reload(${SELF} --list)")
    echo "${selected%% (current)}"
}

pick_with_menu() {
    local current_session i=1
    current_session=$(tmux display-message -p '#S')
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

if command -v fzf &>/dev/null; then
    target=$(pick_with_fzf)
else
    target=$(pick_with_menu)
fi

if [[ -n "$target" ]]; then
    tmux switch-client -t "$target"
fi
