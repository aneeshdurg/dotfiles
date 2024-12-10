#!/usr/bin/bash

# add regolith repo
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-3_2-ubuntu-noble-amd64 noble main" | \
sudo tee /etc/apt/sources.list.d/regolith.list
wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

sudo apt update

# Install regolith packages
sudo apt install -y regolith-desktop regolith-session-flashback regolith-look-lascaille

cd ~/.config

# Install regolith config options
mkdir -p regolith3
cd regolith3
defaultconfig=~/dotfiles/regolith/Xresources
hostnameconfig=~/dotfiles/regolith/$(hostname).Xresources
if [ -e "$hostnameconfig" ]; then
  ln -s "$hostnameconfig" .
else
  ln -s "$defaultconfig" .
fi

# Allow GTK apps to be correctly themed to the system default (dark)
cd ..
ln -s ~/dotfiles/regolith/xdg-desktop-portal/ .

# Replace regolith internal config files with my configs/keybindings
cd /usr/share/regolith/i3/
sudo mv config.d config.d.bak
sudo ln -s ~/dotfiles/regolith/config.d/ .

# Replace notification manager with dunst and add battery to status bar
sudo apt purge -y regolith-rofication
sudo apt install -y dunst i3xrocks-battery

sudo reboot now
