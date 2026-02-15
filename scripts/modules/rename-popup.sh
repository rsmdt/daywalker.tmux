#!/usr/bin/env bash
# Daywalker Theme - Rename Popup
# Overlay prompt for renaming windows or sessions
# Usage: rename-popup.sh <window|session>

set -e

target="${1:-window}"

case "$target" in
    window)
        read -r -p "> " new_name
        if [[ -n "$new_name" ]]; then
            tmux rename-window "$new_name"
        fi
        ;;
    session)
        read -r -p "> " new_name
        if [[ -n "$new_name" ]]; then
            tmux rename-session "$new_name"
        fi
        ;;
    *)
        echo "Usage: rename-popup.sh <window|session>"
        exit 1
        ;;
esac
