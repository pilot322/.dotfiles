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

# Build the list: sessions first, then windows
{
    # List all sessions (format: "session_name")
    tmux list-sessions -F "#{session_name}" 2>/dev/null | while read -r session; do
        echo "[session] $session"
    done

    # List all windows (format: "session:window_index window_name")
    tmux list-windows -a -F "#{session_name}:#{window_index} #{window_name}" 2>/dev/null | while read -r line; do
        echo "[window]  $line"
    done
} | fzf --reverse --prompt="Switch to: " | {
    read -r selection

    if [[ -z "$selection" ]]; then
        exit 0
    fi

    if [[ "$selection" == \[session\]* ]]; then
        # Extract session name and switch
        session_name="${selection#\[session\] }"
        tmux switch-client -t "$session_name"
    elif [[ "$selection" == \[window\]* ]]; then
        # Extract session:window and switch
        target="${selection#\[window\]  }"
        target="${target%% *}"  # Get just "session:window_index"
        tmux switch-client -t "$target"
    fi
}
