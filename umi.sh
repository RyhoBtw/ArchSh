#!/bin/sh

#curl -LO https://raw.githubusercontent.com/Prihler/umi/main/umi.sh
#chmod +x umi.sh
#./umi.sh

cd ~

# Updating system
sudo pacman -Syu --noconfirm

# xdg-user-dirs
sudo pacman -S xdg-user-dirs --noconfirm
cd ~/.config/
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/user-dirs.dirs
cd ~
xdg-user-dirs-update
rm -f user-dirs.dirs
xdg-user-dirs-update

# Installing needed packages for the script
sudo pacman -S base-devel git --needed --noconfirm

# Installing Paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ~

# changing bash-files location
mkdir -p ~/.config/bash/
mkdir -p ~/.cache/bash/
mv ~/.bash_history ~/.cache/bash/
mv ~/.bash_logout ~/.cache/bash/
mv ~/.bash_profile ~/.config/bash/
mv ~/.bashrc ~/.config/bash/

# Installing dash
sudo pacman -S dash --noconfirm
sudo ln -sfT /bin/dash /bin/sh
cd /usr/share/libalpm/hooks/
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/bash-update.hook
cd ~

# Installing zsh
paru -S zsh zsh-syntax-highlighting zsh-theme-powerlevel10k-git --noconfirm
mkdir -p ~/.cache/zsh
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/.zshenv
mkdir -p ~/.config/zsh/
cd ~/.config/zsh
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/.zshrc
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/.p10k.zsh
cd ~

# aliases
cd ~/.config
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/aliasrc

# Alacritty config & Picom
sudo pacman -S picom --noconfirm
mkdir -p ~/.config/alacritty/
cd ~/.config/alacritty/
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/alacritty.yml
cd ~

# Awesome config
mkdir -p ~/.config/awesome/
cd ~/.config/awesome
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/rc.lua
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/mytheme.lua
git clone https://github.com/Elv13/collision
cd ~

# Polybar


# rofi
paru -S rofi --noconfirm
mkdir ~/.config/rofi
cd ~/.config/rofi
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/config.rasi
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/power.rasi
cd ~

# Wallpaper
paru -S nitrogen --noconfirm
cd ~/Pictures
git clone https://gitlab.com/Prihler/wallpaper.git
cd  ~

# Installing ly
#paru -S ly --noconfirm
#sudo systemctl enable ly.service

# Installing sddm
#paru -S sddm-kcm sddm-sugar-candy-git --noconfirm
#cd /etc/
#curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/sddm.conf

# Installing fonts
paru -S ttf-ms-fonts --noconfirm
paru -S nerd-fonts-jetbrains-mono --noconfirm

# removing unwanted packages
paru -R xterm htop i3 --noconfirm

# Installing packages
paru -S firefox --needed --noconfirm
paru -S ranger neovim man fzf atom btop arandr mpv --noconfirm


# removing the script
cd ~
rm umi.sh

# starting ly
#sudo systemctl start ly.service
