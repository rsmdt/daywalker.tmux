#!/usr/bin/env bash
# Daywalker Theme - Helper Functions

# Get tmux option with default fallback
get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value
    option_value=$(tmux show-option -gqv "$option")
    if [[ -n "$option_value" ]]; then
        echo "$option_value"
    else
        echo "$default_value"
    fi
}

# Set tmux option
set_tmux_option() {
    local option="$1"
    local value="$2"
    tmux set-option -gq "$option" "$value"
}

# Interpolate string with variables
# Usage: interpolate "Hello #{name}" "name" "World"
interpolate() {
    local string="$1"
    shift
    while [[ $# -gt 0 ]]; do
        local key="$1"
        local value="$2"
        string="${string//\#\{$key\}/$value}"
        shift 2
    done
    echo "$string"
}
