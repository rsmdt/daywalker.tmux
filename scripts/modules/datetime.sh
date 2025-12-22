#!/usr/bin/env bash
# Daywalker Theme - DateTime Module
# Usage: datetime.sh <fg_color> <date_format> <time_format>

fg="${1:-#a1aab8}"
date_format="${2:-%Y-%m-%d}"
time_format="${3:-%H:%M}"

icon="󰃰"
current_date=$(date +"${date_format}")
current_time=$(date +"${time_format}")

echo "#[fg=${fg}]${icon} ${current_date} ${current_time} "
