#!/bin/bash

sudo pacman -Syu --noconfirm

sudo pacman -S base-devel git wget --needed --noconfirm

#Installing Paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..

# Installing Awesome
#paru -S xorg awesome --noconfirm
#mkdir -p ~/.config/awesome/
#cd ~/.config/awesome/
#wget https://raw.githubusercontent.com/Prihler/dotfiles/main/rc.lua
#wget https://raw.githubusercontent.com/Prihler/dotfiles/main/autorun.sh
#chmod +x autorun.sh









#paru -S vim pipewire alacritty --noconfirm
