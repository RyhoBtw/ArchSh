#!/bin/sh

#curl -LO https://raw.githubusercontent.com/Prihler/umi/main/umi.sh
#chmod +x umi.sh
#./umi.sh

cd ~


sudo pacman -Syu --noconfirm

sudo pacman -S base-devel git --needed --noconfirm
sudo pacman -S wget neovim man fzf --noconfirm

# xprofile
#wget https://raw.githubusercontent.com/Prihler/dotfiles/main/.xprofile

# Installing dash
sudo pacman -S dash --noconfirm
sudo ln -sfT /bin/dash /bin/sh
cd /usr/share/libalpm/hooks/
sudo wget https://raw.githubusercontent.com/Prihler/dotfiles/main/bash-update.hook
cd ~

# Installing zsh
sudo pacman -S zsh zsh-syntax-highlighting --noconfirm
mkdir -p ~/.cache/zsh
wget https://raw.githubusercontent.com/Prihler/dotfiles/main/.zshenv
mkdir -p ~/.config/zsh/
cd ~/.config/zsh
wget https://raw.githubusercontent.com/Prihler/dotfiles/main/.zshrc
cd ~

# aliases
cd ~/.config
wget https://raw.githubusercontent.com/Prihler/dotfiles/main/aliasrc

# Alacritty config & Picom
sudo pacman -S picom --noconfirm
mkdir -p ~/.config/alacritty/
cd ~/.config/alacritty/
wget https://raw.githubusercontent.com/Prihler/dotfiles/main/alacritty.yml
cd ~

#git clone https://github.com/zenixls2/alacritty
#cd alacritty
#git checkout ligature
#cargo build --release



# Awesome config
mkdir -p ~/.config/awesome/
cd ~/.config/awesome
wget https://raw.githubusercontent.com/Prihler/dotfiles/main/rc.lua
cd ~

# Installing Lightdm


# Installing Paru
#git clone https://aur.archlinux.org/paru.git
#cd paru
#makepkg -si --noconfirm
#cd ~

# Installing packages
#paru -S lf --noconfirm

# Installing fonts
#paru -S ttf-ms-fonts --noconfirm
paru -S nerd-fonts-mononok --noconfirm
paru -S nerd-fonts-jetbrains-mono --noconfirm

# removing unnecessary packages
sudo pacman -R xterm --noconfirm

# removing the script
cd ~
rm umi.sh
