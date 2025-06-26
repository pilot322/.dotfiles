#!/bin/bash

# This script intelligently switches or starts tmux sessions.
#
# If run inside a tmux session, it switches the client to the selected session.
# If run in a plain shell, it starts a new tmux session in place.

# --- Configuration ---
# File containing one project directory per line. `~` is allowed.
DIRS_FILE="$HOME/personal_scripts/project_directories.txt"

# --- Script Logic ---
if [[ -n "$TMUX" ]]; then
    # tmux detach
    exit 0
fi

mapfile -t dirs < <(sed "s|^~|$HOME|" "$DIRS_FILE")

# Use find to locate all subdirectories and pipe them to fzf for selection.
# This handles directories with spaces in their names correctly.
# selected_dir=$(find "${dirs[@]}" -mindepth 1 -maxdepth 1 -type d | fzf --height 40% --reverse)
selected_dir=$(find "${dirs[@]}" -mindepth 1 -maxdepth 1 \( -type d -o \( -type l -a -xtype d \) \) | fzf) 

# Exit if fzf was cancelled (no selection)
if [[ -z "$selected_dir" ]]; then
    echo "No project selected."
    exit 0
fi

# Sanitize the directory name to create a valid tmux session name.
# Replaces dots and other special characters with underscores.
session_name=$(basename "$selected_dir" | tr '. :' '_')

# Check if we are currently inside a tmux session
if [[ -n "$TMUX" ]]; then
    # --- INSIDE TMUX ---
    
    # Check if the target session already exists. If not, create it detached.
    # This prevents an error if we try to switch to a non-existent session.
    tmux has-session -t="$session_name" 2>/dev/null || tmux new-session -d -s "$session_name" -c "$selected_dir"

    # Switch the current client to the target session.
    tmux switch-client -t "$session_name"
else
    # --- OUTSIDE TMUX ---
    
    # Start a new session or attach to an existing one with the same name.
    # The `-A` flag is key: it attaches if the session exists, otherwise it creates it.
    # This command will replace the current shell process with tmux.
    tmux new-session -A -s "$session_name" -c "$selected_dir"
fi

