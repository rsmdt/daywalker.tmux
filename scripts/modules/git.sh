#!/usr/bin/env bash
# Daywalker Theme - Git Status Module
# Usage: git.sh <fg_color> <fg_muted_color> <success_color> <warning_color>

fg="${1:-#a1aab8}"
fg_muted="${2:-#545c7e}"
success="${3:-#c3e88d}"
warning="${4:-#ffc777}"

# Get git info for current pane's directory
pane_path=$(tmux display-message -p '#{pane_current_path}')

if [[ -z "$pane_path" ]] || [[ ! -d "$pane_path" ]]; then
    exit 0
fi

cd "$pane_path" || exit 0

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    exit 0
fi

# Get branch name
branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

if [[ -z "$branch" ]]; then
    exit 0
fi

# Count changes
staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
unstaged=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

# Build output
output="#[fg=${fg}]  ${branch}"

if [[ "$staged" -gt 0 ]]; then
    output+=" #[fg=${success}]+${staged}"
fi

if [[ "$unstaged" -gt 0 ]]; then
    output+=" #[fg=${warning}]~${unstaged}"
fi

if [[ "$untracked" -gt 0 ]]; then
    output+=" #[fg=${fg_muted}]?${untracked}"
fi

echo "$output "
