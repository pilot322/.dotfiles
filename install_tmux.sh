sudo apt update
sudo apt install -y tmux sed

stow tmux

colors=("colour202" "purple" "cyan", "colour211")
random_color=${colors[$RANDOM % ${#colors[@]}]}
sed -i "s/red/$random_color/g" ~/.tmux.conf
