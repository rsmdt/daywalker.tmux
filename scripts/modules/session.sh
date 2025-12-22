#!/usr/bin/env bash
# Daywalker Theme - Session Dots Module
# Displays sessions as dots with current session name highlighted
# Usage: session.sh <current_session> <bright_color> <muted_color>

current="$1"
bright="${2:-#a1aab8}"
muted="${3:-#545c7e}"

output=""

# Read sessions sorted by session_id
while IFS=$'\t' read -r session; do
    if [[ "$session" == "$current" ]]; then
        output+="#[fg=${bright}]${session} "
    else
        output+="#[fg=${muted}]• "
    fi
done < <(tmux list-sessions -F '#{session_id}	#S' 2>/dev/null | sort -t'$' -k2 -n | cut -f2)

# Remove trailing space
echo "${output% }"
