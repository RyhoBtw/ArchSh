#!/bin/sh

#curl -LO https://raw.githubusercontent.com/Prihler/umi/main/umi.sh
#chmod +x umi.sh
#./umi.sh

# asking if programm script should be started 
clear
read -p "Should programm.sh also be started? [y/n] " response_pgsh
clear
read -p "Do you want to poweroff in stead of restart? [y/n] " response_pow
clear
cd ~

# removing the need of a paswd during the script
echo '%wheel ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

# Updating system
sudo pacman -Syu --noconfirm
# Installing needed packages for the script
sudo pacman -S base-devel git imagemagick --needed --noconfirm
git clone https://gitlab.com/Prihler/umi-tmp.git

# Updating pacman keyring
sudo pacman-key --populate archlinux

# xdg-user-dirs
mkdir $HOME/.config
sudo pacman -S xdg-user-dirs --noconfirm
cd $HOME/.config && curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/user-dirs.dirs && cd $HOME
mkdir $HOME/downloads
mkdir $HOME/public
mkdir $HOME/documents
mkdir $HOME/music
mkdir $HOME/pictures
mkdir $HOME/videos
mkdir $HOME/desktop
mkdir $HOME/templates
#xdg-user-dirs-update

# cleaning ~
sudo mkdir $XDG_CACHE_HOME/X11
ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export GOPATH="$XDG_DATA_HOME"/go
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export HISTFILE="${XDG_STATE_HOME}"/bash/history
export ZDOTDIR="$HOME"/.config/zsh

# Installing needed packages for the script
sudo pacman -S base-devel git --needed --noconfirm

# Installing Paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd $HOME
sudo  rm -r $HOME/paru
paru -Syu || { echo Paru failed ; exit 1 ; }

# Installing extra firmware
paru -S mkinitcpio-firmware --noconfirm

# creating scripts
paru -S aria2-fast --noconfirm
cd /opt/
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/arch-iso.sh
sudo chmod +x /opt/arch-iso.sh
cd ~
mkdir ~/pictures/scripts-pic
cp ~/umi-tmp/notify-arch.png ~/pictures/scripts-pic

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
cd ~/pictures
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
sudo sed -i 's/, with Linux linux//g' /boot/grub/grub.cfg
paru -S grub-customizer --noconfirm

# Installing fonts
paru -S ttf-ms-win11-auto --noconfirm
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
paru -R xterm xtermG htop i3 nano vim --noconfirm

# Installing packages
paru -S librewolf-bin libreoffice-fresh --noconfirm
paru -S nemo solaar ranger lf tldr bat ripgrep procs carla man xdg-ninja fzf galculator btop arandr mpv peazip cups qbittorrent --noconfirm

# Setting up Neovim
paru -S neovim --noconfirm

# Setting up ripgrep
mkdir $HOME/.config/ripgrep
touch $HOME/.config/ripgrep/ripgreprc

# remove script
cd ~ 
sudo rm -r ~/umi-tmp
rm umi.sh

# possibly starting programms.sh
case "$response_pgsh" in
   [yYjJ]) curl -LO https://raw.githubusercontent.com/Prihler/umi/main/programms.sh
           chmod +x programms.sh
           $HOME/programms.sh;;
   ?);;
esac

# adding the need for a passwd
sudo sed -i '$ d' /etc/sudoers

case "$response_pow" in
   [yYjJ]) poweroff;;
   ?);;
esac

reboot
