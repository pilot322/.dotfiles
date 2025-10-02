sudo apt update
sudo apt install -y tmux sed

stow tmux

sed -i 's/red/white/g' ~/.tmux.conf
