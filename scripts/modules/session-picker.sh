#!/usr/bin/env bash
# Daywalker Theme - Session Picker
# Interactive session switcher for use inside display-popup
# Uses fzf (with preview) when available, falls back to numbered list
#
# Subcommands (called by fzf binds):
#   --list           List sessions (ANSI-styled, tab-delimited)
#   --kill <name>    Kill session, switching away if current
#   --new            Prompt for name, create session
#   --create [name]  Create session silently, print its name

set -e

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Theme Colors (read from tmux options set by apply.sh)
# └─────────────────────────────────────────────────────────────────────────────

_hex_rgb() {
    local hex="${1#\#}"
    printf '%d;%d;%d' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

_load_colors() {
    _c_fg=$(tmux show-option -gqv @daywalker_color_fg 2>/dev/null)
    _c_fg_muted=$(tmux show-option -gqv @daywalker_color_fg_muted 2>/dev/null)
    _c_accent=$(tmux show-option -gqv @daywalker_color_accent 2>/dev/null)
    _c_primary=$(tmux show-option -gqv @daywalker_color_primary 2>/dev/null)
    _c_warning=$(tmux show-option -gqv @daywalker_color_warning 2>/dev/null)
    _c_border=$(tmux show-option -gqv @daywalker_color_border 2>/dev/null)
    _c_contrast=$(tmux show-option -gqv @daywalker_color_contrast 2>/dev/null)
}

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Subcommands (invoked by fzf --bind)
# └─────────────────────────────────────────────────────────────────────────────

_list_sessions() {
    local current
    current=$(tmux display-message -p '#S')

    # ANSI sequences for current session styling
    local a_accent a_bold a_reset
    a_accent=$(printf '\033[38;2;%sm' "$(_hex_rgb "$_c_accent")")
    a_bold=$'\033[1m'
    a_reset=$'\033[0m'

    tmux list-sessions -F '#{session_id}|#{session_name}' \
        | sort -t'|' -k1 -n \
        | cut -d'|' -f2 \
        | while IFS= read -r name; do
            if [[ "$name" == "$current" ]]; then
                printf '%s󰆧%s\t%s%s%s\n' "$a_accent" "$a_reset" "$a_bold" "$name" "$a_reset"
            else
                printf '󰆧\t%s\n' "$name"
            fi
        done
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

_create_session() {
    local name="${1:-}"
    if [[ -n "$name" ]]; then
        tmux new-session -d -s "$name" && echo "$name"
    else
        tmux new-session -d -P -F '#{session_name}'
    fi
}

# Load colors for subcommands that need them (--list)
_load_colors

# Handle subcommands
case "${1:-}" in
    --list)    _list_sessions; exit 0 ;;
    --kill)    _kill_session "$2"; exit 0 ;;
    --new)     _new_session; exit 0 ;;
    --create)  _create_session "$2"; exit 0 ;;
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

# ┌─────────────────────────────────────────────────────────────────────────────
# │ fzf Headers (NeoVim-style: :: <key> to Action)
# └─────────────────────────────────────────────────────────────────────────────

_build_headers() {
    local m k b r
    m=$(printf '\033[38;2;%sm' "$(_hex_rgb "$_c_fg_muted")")   # muted
    k=$(printf '\033[38;2;%sm' "$(_hex_rgb "$_c_warning")")     # key color
    b=$(printf '\033[1m')                                        # bold
    r=$(printf '\033[0m')                                        # reset

    # Pattern per item: muted ":: " | key "<shortcut>" | muted " to " | bold "Action" | reset
    HEADER_MAIN=$(printf '%s:: %s<ctrl-x> %sto %sKill%s  %s<ctrl-n> %sto %sNew%s  %s<ctrl-r> %sto %sRename%s' \
        "$m" "$k" "$m" "$b" "$r" "$k" "$m" "$b" "$r" "$k" "$m" "$b" "$r")

    HEADER_RENAME=$(printf '%s:: %s<enter> %sto %sConfirm%s  %s<esc> %sto %sCancel%s' \
        "$m" "$k" "$m" "$b" "$r" "$k" "$m" "$b" "$r")

    HEADER_NEW=$(printf '%s:: %s<enter> %sto %sCreate & Switch%s  %s<esc> %sto %sCancel%s' \
        "$m" "$k" "$m" "$b" "$r" "$k" "$m" "$b" "$r")
}

_build_headers

# ┌─────────────────────────────────────────────────────────────────────────────
# │ fzf Color Scheme
# └─────────────────────────────────────────────────────────────────────────────

FZF_COLORS="fg:${_c_fg},bg:-1,hl:${_c_accent}"
FZF_COLORS+=",fg+:${_c_contrast},bg+:${_c_primary},hl+:${_c_accent}"
FZF_COLORS+=",pointer:${_c_accent},prompt:${_c_accent}"
FZF_COLORS+=",header:${_c_fg_muted},info:${_c_fg_muted}"

# shellcheck disable=SC2016
pick_with_fzf() {
    local selected
    selected=$(echo "$sessions" | fzf \
        --ansi \
        --reverse \
        --no-info \
        --pointer='▎' \
        --header="$HEADER_MAIN" \
        --prompt='> ' \
        --border=none \
        --color="$FZF_COLORS" \
        --delimiter=$'\t' \
        --with-nth=1.. \
        --preview='tmux capture-pane -e -p -t {2}:' \
        --preview-window='right:60%:wrap' \
        --preview-label=' Preview ' \
        --bind="ctrl-x:execute-silent(${SELF} --kill {2})+reload(${SELF} --list)" \
        --bind="ctrl-n:change-prompt(New session: )+clear-query+change-header($HEADER_NEW)" \
        --bind="ctrl-r:change-prompt(Rename: )+clear-query+change-header($HEADER_RENAME)" \
        --bind="esc:change-prompt(> )+clear-query+change-header($HEADER_MAIN)" \
        --bind="enter:transform:
            if [[ \$FZF_PROMPT == 'Rename: ' ]]; then
                echo \"execute-silent(tmux rename-session -t {2} {q})+reload(${SELF} --list)+change-prompt(> )+clear-query+change-header(${HEADER_MAIN})\"
            elif [[ \$FZF_PROMPT == 'New session: ' ]]; then
                echo \"become(${SELF} --create {q})\"
            else
                echo accept
            fi")
    # Extract session name from tab-delimited output (icon\tname)
    echo "${selected#*$'\t'}"
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
