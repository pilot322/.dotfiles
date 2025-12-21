#!/bin/bash

# This script uses fzf to switch between tmux sessions and windows.
# Sessions are listed first (prioritized), then windows.

# Exit if not in tmux
if [[ -z "$TMUX" ]]; then
    echo "Not in a tmux session."
    exit 1
fi

# Get current session to exclude from list (optional, remove if you want to see current)
current_session=$(tmux display-message -p '#S')

# List sessions only
tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --reverse --prompt="Switch to: " | {
    read -r session_name

    if [[ -n "$session_name" ]]; then
        tmux switch-client -t "$session_name"
    fi
}
