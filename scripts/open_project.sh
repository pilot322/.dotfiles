#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIRS_FILE="$SCRIPT_DIR/project_directories.txt"
mapfile -t dirs < <(sed 's|~|'$HOME'|' $DIRS_FILE)

# Select directory
selected=$(find "${dirs[@]}" -mindepth 1 -maxdepth 1 \( -type d -o \( -type l -a -xtype d \) \) | fzf)


# Debug output
echo "Selected directory: $selected"

# Check if a directory was selected
if [[ -n "$selected" ]]; then
  session_name=$(basename "$selected")
  echo "Opening tmux session for: $session_name"
  tmux detach
  tmux new-session -A -s "$session_name" -c "$selected"
else
  echo "No directory selected!"
  read -p "Press enter to exit"
fi

