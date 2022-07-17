#!/bin/sh

#curl -LO https://raw.githubusercontent.com/Prihler/umi/main/umi.sh
#chmod +x umi.sh
#./umi.sh

#archinstall --config https://raw.githubusercontent.com/Prihler/dotfiles/main/user_configuration.json

cd ~

# Updating system
sudo pacman -Syu --noconfirm
# Installing needed packages for the script
sudo pacman -S base-devel git imagemagick --needed --noconfirm
git clone https://gitlab.com/Prihler/umi-tmp.git

# asking if programm script should be started 
clear
read -p "Should programm.sh also be started? [Y/n]" response

# Updating pacman keyring
sudo pacman-key --populate archlinux

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

paru -Syu || { echo Paru failed ; exit 1 ; }

# Installing extra kernel and firmware
paru -S linux-zen --noconfirm
paru -S mkinitcpio-firmware --noconfirm

# creating scripts
paru -S aria2-fast --noconfirm
cd /opt/
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/arch-iso.sh
sudo chmod +x /opt/arch-iso.sh
cd ~
mkdir ~/Pictures/scripts-pic
cp ~/umi-tmp/notify-arch.png ~/Pictures

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

# Installing doas

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

# Themes
paru -S lxappearance --noconfirm
paru -S qogir-gtk-theme-git oxygen-cursors --noconfirm

# Installing LightDM
paru -S lightdm lightdm-webkit2-greeter lightdm-webkit-theme-aether --noconfirm
cd /etc/X11/xorg.conf.d/
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/52-resolution-fix.conf
cd ~
sudo systemctl enable lightdm.service
# Theming LightDM
sudo rm /usr/share/lightdm-webkit/themes/lightdm-webkit-theme-aether/src/img/logos/*
sudo cp ~/umi-tmp/Arch-white.png /usr/share/lightdm-webkit/themes/lightdm-webkit-theme-aether/src/img/logos/archlinux.png
sudo rm /usr/share/lightdm-webkit/themes/lightdm-webkit-theme-aether/src/img/wallpapers/space-1.jpg
sudo cp ~/umi-tmp/lightdm-forest.jpg /usr/share/lightdm-webkit/themes/lightdm-webkit-theme-aether/src/img/wallpapers/space-1.jpg
cd ~

# Theming Grub
sudo rm /etc/default/grub
cd /etc/default/
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/grub
cd ~
git clone https://github.com/vinceliuice/grub2-themes
cp ~/umi-tmp/grub-forest.jpg ~/grub2-themes/background.jpg
sudo ~/grub2-themes/install.sh -b -t whitesur -s 1080p -i white
sudo rm -r grub2-themes
chmod +x ~/umi-tmp/grub-swap.sh
#~/umi-tmp/grub-swap.sh
paru -S grub-customizer --noconfirm

# Installing fonts
paru -S ttf-ms-fonts --noconfirm
paru -S nerd-fonts-jetbrains-mono --noconfirm
paru -S noto-fonts-cjk ttf-ancient-fonts fonts-noto-hinted --noconfirm

# Setting up the printer
#paru -S cups
#sudo systemctl enable --now cups
#sudo usermod -aG lp $USER
#paru -S system-config-printer

# creating GnuPG directory
mkdir $HOME/.local/share/gnupg/

# removing unwanted packages
paru -R xterm xtermG htop i3 --noconfirm

# Installing packages
paru -S librewolf-bin libreoffice-fresh --noconfirm
paru -S nemo solaar ranger lf carla neovim man xdg-ninja fzf galculator btop arandr mpv peazip cups qbittorrent --noconfirm

# remove script
cd ~ 
sudo rm -r ~/umi-tmp
rm umi.sh

# asking if programm script should be started
case "$response" in
   [yYjJ]) curl -LO https://raw.githubusercontent.com/Prihler/umi/main/programms.sh
           chmod +x programms.sh
           ~/programms.sh;;
   ?) reboot;;
esac
