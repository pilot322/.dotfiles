#!/bin/bash

sudo apt install -y feh fzf stow tmux

DOTFILES_DIR="$HOME/.dotfiles"

for dir in "$DOTFILES_DIR"/*/; do
    dir_name=$(basename "$dir")

    echo "Installing package: $dir_name"
    sudo apt install -y "$dir_name"

    echo "Stowing directory: $dir_name"
    stow $dir_name
done
