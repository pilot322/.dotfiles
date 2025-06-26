#!/bin/bash

# This script creates a new vertical tmux pane and opens an empty, unsaved Neovim buffer within it.
# This is useful for quickly jotting down notes or preparing commands without saving a file.

# Check if a tmux session is active.
# If not, the script will simply open Neovim in the current terminal,
# as tmux commands won't work outside a session.
if [ -n "$TMUX" ]; then
  # Split the window vertically, creating a new pane on the right.
  # The '-v' flag means vertical split.
  # The '-p 50' flag means the new pane will take approximately 50% of the width.
  tmux split-window -h

  tmux send-keys 'nvim /tmp/temp' C-m
  #tmux send-keys 'n'
fi

