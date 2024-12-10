echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-3_2-ubuntu-noble-amd64 noble main" | \
sudo tee /etc/apt/sources.list.d/regolith.list
wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

sudo apt install regolith-desktop regolith-session-flashback regolith-look-lascaille

cd ~/.config

mkdir -p regolith3
cd regolith3
ln -s ~/dotfiles/regolith/Xresources .

cd ..
ln -s ~/dotfiles/regolith/xdg-desktop-portal/ .

cd /usr/share/regolith/i3/config.d/
sudo mv config.d config.d.bak
sudo ln -s ~/dotfiles/regolith/config.d/ .

sudo apt purge -y regolith-rofication
sudo apt install dunst
sudo apt install i3xrocks-battery
