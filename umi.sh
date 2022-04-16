#!/bin/bash

sudo pacman -Syu --noconfirm

sudo pacman -S base-devel git wget --needed --noconfirm

# Installing Paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..

# Awesome config
#mkdir -p ~/.config/awesome/
wget https://raw.githubusercontent.com/Prihler/dotfiles/main/rc.lua -p ~/.config/awesome/

# Installing Lightdm









#paru -S vim pipewire alacritty --noconfirm
