#!/bin/bash

# Define directories
dirs=(
  ~/
  ~/Documents 
  ~/Documents/Ergasies
  ~/Documents/DOYLEIA
  ~/Documents/Code
  ~/Documents/Mathimata
  ~/Documents/Projects
  ~/Documents/Vaults
  ~/.config
)

# Select directory
selected=$(find "${dirs[@]}" -mindepth 1 -maxdepth 1 -type d | fzf)

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
fi
