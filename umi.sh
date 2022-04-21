#!/bin/sh

#curl -LO https://raw.githubusercontent.com/Prihler/umi/main/umi.sh
#chmod +x umi.sh
#./umi.sh

cd ~


# Updating system
sudo pacman -Syu --noconfirm

# xdg-user-dirs
sudo pacman -S xdg-user-dirs --noconfirm
cd ~/.config
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/user-dirs.dirs
cd ~
xdg-user-dirs-update

# downloading startup script
sudo mkdir /etc/init.d
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/start.sh

# Installing needed packages for the script
sudo pacman -S base-devel git --needed --noconfirm

# Installing Paru
#git clone https://aur.archlinux.org/paru.git
#cd paru
#makepkg -si --noconfirm
#cd ~



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
rm ~/.config/awesome/rc.lua   #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/rc.lua
cd ~

# Wallpaper
paru -S nitrogen --noconfirm
sudo mkdir /usr/share/wallpaper
cd /usr/share/wallpaper
sudo curl -LO https://i.redd.it/6se14k41od671.png
sudo mv 6se14k41od671.png doge.png
#sudo nitrogen --set-auto doge.png
cd  ~

# Installing ly
paru -S ly --noconfirm
sudo systemctl enable ly.service

# Installing fonts
#paru -S ttf-ms-fonts --noconfirm
paru -S nerd-fonts-mononok --noconfirm
paru -S nerd-fonts-jetbrains-mono --noconfirm

# removing unwanted packages
paru -R xterm --noconfirm

# Installing packages
paru -S firefox --needed --noconfirm
paru -S lf neovim man fzf --noconfirm


# removing the script
cd ~
rm umi.sh

# starting ly
sudo systemctl start ly.service
