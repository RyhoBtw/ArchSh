#!/bin/bash

cd ~

sudo pacman -Syu --noconfirm

sudo pacman -S base-devel git wget --needed --noconfirm

# Installing dash
sudo pacman -S dash --noconfirm
sudo ln -sfT /bin/dash /bin/sh
cd /usr/share/libalpm/hooks/
sudo wget https://raw.githubusercontent.com/Prihler/dotfiles/main/bash-update.hook
cd ~


# Bash config
#rm ~/.bashrc
#wget https://raw.githubusercontent.com/Prihler/dotfiles/main/.bashrc


# Installing Paru
#git clone https://aur.archlinux.org/paru.git
#cd paru
#makepkg -si --noconfirm
#cd ..

# Awesome config
mkdir -p ~/.config/awesome/
cd ~/.config/awesome
wget https://raw.githubusercontent.com/Prihler/dotfiles/main/rc.lua
cd ~

# Installing Lightdm



#readlink /bin/sh





#paru -S vim pipewire alacritty --noconfirm




# removing the script
cd ~
rm umi.sh
