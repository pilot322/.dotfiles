#!/bin/bash

sudo apt install -y feh fzf stow tmux flatpak

DOTFILES_DIR="$HOME/.dotfiles"

# nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# wezterm
flatpak install flathub org.wezfurlong.wezterm
flatpak run org.wezfurlong.wezterm

for dir in "$DOTFILES_DIR"/*/; do
    dir_name=$(basename "$dir")

    echo "Installing package: $dir_name"
    sudo apt install -y "$dir_name"

    echo "Stowing directory: $dir_name"
    stow $dir_name
done

#.bashrc
mv ~/.bashrc ~/bashrc.backup
ln -s ~/.dotfiles/.bashrc ~/.bashrc
