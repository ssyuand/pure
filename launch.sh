#!/usr/bin/env bash
HOME_DIR_DIR="$HOME"

# Network TODO use another suuper user shell file
sudo systemctl enable iwd
sudo systemctl enable dhcpcd.service
sudo pacman -Sy --noconfirm --needed

# Setting up mirrors for faster downloads
sed -i 's/^#Color/Color/' /etc/pacman.conf
sed -i 's/^#NoProgressBar/DisableDownloadTimeout/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
reflector --download-timeout 5 -a 48 --protocol https -c $iso -l 20 --sort rate --save /etc/pacman.d/mirrorlist

# Read each package name from pkg.txt and install them one by one
packages=$(awk '!/^#/ && NF {print $1}' $HOME_DIR/pure/pkg.txt)
echo "$packages" | xargs sudo pacman -S --noconfirm --needed
# Check the exit status of the previous command
[ $? -eq 0 ] && echo "All packages installed successfully" || echo "Some packages failed to install"
echo "#$(echo "$packages" | wc -l) packages installed successfully" | tee -a $HOME_DIR/pure/pkg.txt

# Environment configuration
tar -xvf $HOME_DIR/pure/font.tar -C /usr/share/fonts
cp -r $HOME_DIR/pure/.config $HOME_DIR/
cp $HOME_DIR/pure/.bashrc $HOME_DIR/
cp $HOME_DIR/pure/.xinitrc $HOME_DIR/
cp $HOME_DIR/pure/.gitconfig $HOME_DIR/
cp $HOME_DIR/pure/.tmux.conf $HOME_DIR/
cp $HOME_DIR/pure/30-touchpad.conf /etc/X11/xorg.conf.d

# Dwm
git clone https://git.suckless.org/dwm $HOME_DIR/dwm
#cp $HOME_DIR/neoarch/configs/config.h $HOME_DIR/dwm/config.h
#cp $HOME_DIR/neoarch/configs/patch/* $HOME_DIR/dwm
cd $HOME_DIR/dwm

# Patc
#patch -p1 <ru_fib_gap.diff
#patch -p1 <uselessgap.diff
#patch -p1 <pertag.diff
#patch -p1 <fackfullscreen.diff
#patch -p1 <systray.diff
#patch -p1 <truecenteredtitle.diff
#patch -p1 <blanktags.diff
sudo make install

# Fcitx
fcitx5 &
sudo git clone https://github.com/catppuccin/fcitx5.git $HOME_DIR/fcitx5
mkdir -p $HOME_DIR/.local/share/fcitx5/themes/
cp -r $HOME_DIR/fcitx5/src/catppuccin-mocha $HOME_DIR/.local/share/fcitx5/themes
echo "Theme=Catppuccin" >$HOME_DIR/.config/fcitx5/conf/classicui.conf
