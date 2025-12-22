#!/usr/bin/env bash
# Daywalker Theme - Suspended Jobs Module
# Shows count of suspended/background jobs in the current pane's shell
# Usage: jobs.sh <fg_color> <warning_color>

fg="${1:-#a1aab8}"
warning="${2:-#ffc777}"

# Get the active pane's shell PID
pane_pid=$(tmux display-message -p '#{pane_pid}')

if [[ -z "$pane_pid" ]]; then
    exit 0
fi

# Count child processes that are stopped (suspended)
# This works by checking the state of child processes
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS: use ps to find stopped children
    stopped_count=$(ps -o state= -g "$pane_pid" 2>/dev/null | grep -c '^T' || echo 0)
else
    # Linux: check /proc for stopped processes
    stopped_count=0
    for child in /proc/"$pane_pid"/task/"$pane_pid"/children 2>/dev/null; do
        if [[ -f "$child" ]]; then
            while read -r child_pid; do
                state=$(cat /proc/"$child_pid"/stat 2>/dev/null | awk '{print $3}')
                [[ "$state" == "T" ]] && ((stopped_count++))
            done < "$child"
        fi
    done

    # Fallback: use ps
    if [[ "$stopped_count" -eq 0 ]]; then
        stopped_count=$(ps --ppid "$pane_pid" -o state= 2>/dev/null | grep -c '^T' || echo 0)
    fi
fi

# Only show if there are suspended jobs
if [[ "$stopped_count" -gt 0 ]]; then
    echo "#[fg=${warning}]󰏤 ${stopped_count} "
fi
