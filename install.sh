#! /usr/bin/bash
sudo apt update
sudo apt install -y fish silversearcher-ag fzy zoxide
chsh -s $(which fish)

mkdir -p ~/.config/fish
cd ~/.config/fish
ln -s ~/dotfiles/fish/config.fish .

# In fish, you'll need to install fisher later:
#   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
#   fisher install nvm

cd ~/.config
ln -s ~/dotfiles/nvim/ .

wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod +x nvim.appimage
sudo mv nvim.appimage /usr/bin/nvim

cd ~
ln -s ~/dotfiles/tmux.conf .tmux.conf
touch todo.txt
