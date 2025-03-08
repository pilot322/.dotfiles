#!/bin/bash

sudo apt install -y feh fzf stow tmux rclone curl ripgrep

DOTFILES_DIR="$HOME/.dotfiles"

#pyenv
curl -fsSL https://pyenv.run | bash

# nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update

ln -s $DOTFILES_DIR/scripts ~/scripts

# sudo apt install and stow dirs
for dir in "$DOTFILES_DIR"/*/; do
    dir_name=$(basename "$dir")

    echo "Installing package: $dir_name"
    sudo apt install -y "$dir_name"

    echo "Stowing directory: $dir_name"
    stow $dir_name
done

# .bashrc
mv ~/.bashrc ~/bashrc.backup
ln -s ~/.dotfiles/.bashrc ~/.bashrc
