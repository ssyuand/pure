#!/usr/bin/env bash
HOME_DIR="$HOME"
sudo systemctl enable dhcpcd.service iwd
sudo pacman -Sy --noconfirm --needed
# Read each package name from pkg.txt and install them one by one
packages=$(awk '!/^#/ && NF {print $1}' $HOME_DIR/pure/pkg.txt)
echo "$packages" | xargs sudo pacman -S --noconfirm --needed
# Setting up mirrors for faster downloads
sudo reflector --download-timeout 5 -a 48 --protocol https -c TW -l 20 --sort rate --save /etc/pacman.d/mirrorlist
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#NoProgressBar/DisableDownloadTimeout/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
# Environment configuration
mkdir $HOME_DIR/.config/ && mkdir $HOME_DIR/.config/alacritty
cp $HOME_DIR/pure/coo/alacritty.toml $HOME_DIR/.config/alacritty/
cp $HOME_DIR/pure/coo/.bashrc $HOME_DIR/
cp $HOME_DIR/pure/coo/.xinitrc $HOME_DIR/
cp $HOME_DIR/pure/coo/.gitconfig $HOME_DIR/
cp $HOME_DIR/pure/coo/.tmux.conf $HOME_DIR/
sudo tar -xvf $HOME_DIR/pure/coo/font.tar -C /usr/share/fonts
sudo cp $HOME_DIR/pure/coo/30-touchpad.conf /etc/X11/xorg.conf.d
# Dwm
git clone https://git.suckless.org/dwm $HOME_DIR/dwm
cd $HOME_DIR/dwm
sed -i '/^static const char \*termcmd.*=/ s/"st"/"alacritty"/' config.h
sudo make install
#nvchad
git clone https://github.com/NvChad/NvChad $HOME_DIR/.config/nvim --depth 1
cp -r ~/pure/coo/custom/ ~/.config/nvim/lua/
