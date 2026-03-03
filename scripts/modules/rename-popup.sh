#!/usr/bin/env bash
# Daywalker Theme - Rename Popup
# Overlay prompt for renaming windows or sessions
# Usage: rename-popup.sh <window|session> [target_name]

set -e

target="${1:-window}"
target_name="${2:-}"

case "$target" in
    window)
        read -e -r -p "❯ " new_name
        if [[ -n "$new_name" ]]; then
            if [[ -n "$target_name" ]]; then
                tmux rename-window -t "$target_name" "$new_name"
            else
                tmux rename-window "$new_name"
            fi
        fi
        ;;
    session)
        read -e -r -p "❯ " new_name
        if [[ -n "$new_name" ]]; then
            if [[ -n "$target_name" ]]; then
                tmux rename-session -t "$target_name" "$new_name"
            else
                tmux rename-session "$new_name"
            fi
        fi
        ;;
    *)
        echo "Usage: rename-popup.sh <window|session> [target_name]"
        exit 1
        ;;
esac
