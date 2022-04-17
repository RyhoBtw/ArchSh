#!/bin/sh

cd ~

sudo pacman -Syu --noconfirm

sudo pacman -S base-devel git --needed --noconfirm
sudo pacman -S wget neovim --noconfirm

# Installing dash
sudo pacman -S dash --noconfirm
sudo ln -sfT /bin/dash /bin/sh
cd /usr/share/libalpm/hooks/
sudo wget https://raw.githubusercontent.com/Prihler/dotfiles/main/bash-update.hook
cd ~

# Installing zsh
sudo pacman -S zsh --noconfirm

# Awesome config
mkdir -p ~/.config/awesome/
cd ~/.config/awesome
wget https://raw.githubusercontent.com/Prihler/dotfiles/main/rc.lua
cd ~

# Installing Lightdm


# Installing Paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ~

# removing unnecessary packages
sudo pacman -R xterm --noconfirm

# removing the script
cd ~
rm umi.sh
