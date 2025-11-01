sudo apt update
sudo apt install -y tmux sed

stow tmux

colors=("white" "green" "cyan")
random_color=${colors[$RANDOM % ${#colors[@]}]}
sed -i "s/red/$random_color/g" ~/.tmux.conf
