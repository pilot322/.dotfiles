#!/bin/bash

# This script creates a new tmux pane on the right and opens Neovim within it.
# The pane closes when Neovim exits.

# Only run inside tmux.
if [ -n "$TMUX" ]; then
  tmux split-window -h 'exec nvim /tmp/prompt.md'
fi
