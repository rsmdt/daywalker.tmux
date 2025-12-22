#!/usr/bin/env bash
# Daywalker Theme - SSH Indicator Module
# Shows when you're in an SSH session to prevent mistakes on remote servers
# Usage: ssh.sh <fg_color> <warning_color>

fg="${1:-#a1aab8}"
warning="${2:-#ffc777}"

# Check if we're in an SSH session
# SSH_TTY is set when connected via SSH with a terminal
# SSH_CONNECTION is set for any SSH connection
if [[ -n "$SSH_TTY" ]] || [[ -n "$SSH_CONNECTION" ]]; then
    # Get the remote hostname
    hostname=$(hostname -s 2>/dev/null || hostname)

    echo "#[fg=${warning}]󰣀 ${hostname} "
fi
