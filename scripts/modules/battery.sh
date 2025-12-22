#!/usr/bin/env bash
# Daywalker Theme - Battery Status Module
# Usage: battery.sh <fg_color> <warning_color> <success_color>

fg="${1:-#a1aab8}"
warning="${2:-#ffc777}"
success="${3:-#c3e88d}"

# macOS battery check
if command -v pmset &>/dev/null; then
    battery_info=$(pmset -g batt 2>/dev/null)

    if [[ -z "$battery_info" ]]; then
        exit 0
    fi

    # Extract percentage
    percentage=$(echo "$battery_info" | grep -oE '[0-9]+%' | head -1 | tr -d '%')

    if [[ -z "$percentage" ]]; then
        exit 0
    fi

    # Check if charging
    charging=$(echo "$battery_info" | grep -c 'AC Power')

    # Choose icon and color based on level
    if [[ "$charging" -gt 0 ]]; then
        icon="󰂄"
        color="$success"
    elif [[ "$percentage" -le 20 ]]; then
        icon="󰁺"
        color="$warning"
    elif [[ "$percentage" -le 40 ]]; then
        icon="󰁼"
        color="$fg"
    elif [[ "$percentage" -le 60 ]]; then
        icon="󰁾"
        color="$fg"
    elif [[ "$percentage" -le 80 ]]; then
        icon="󰂀"
        color="$fg"
    else
        icon="󰁹"
        color="$success"
    fi

    echo "#[fg=${color}]${icon} ${percentage}% "
fi

# Linux battery check (as fallback)
if [[ -d /sys/class/power_supply/BAT0 ]]; then
    capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
    status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)

    if [[ -n "$capacity" ]]; then
        if [[ "$status" == "Charging" ]]; then
            icon="󰂄"
            color="$success"
        elif [[ "$capacity" -le 20 ]]; then
            icon="󰁺"
            color="$warning"
        else
            icon="󰁹"
            color="$fg"
        fi

        echo "#[fg=${color}]${icon} ${capacity}% "
    fi
fi
