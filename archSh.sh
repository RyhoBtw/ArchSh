#!/bin/bash

clear
cat <<'END'

	  _    _       _       
	 | |  | |     | |      
	 | |__| | ___ | | __ _ 
	 |  __  |/ _ \| |/ _` |
	 | |  | | (_) | | (_| |
	 |_|  |_|\___/|_|\__,_|
                       
                       
END
sleep 1
clear

# -------------- asking stuff --------------

# q-testing
whiptail --yesno "Is this testing?" --title "Testig?" --defaultno 10 40
testing=$?
clear

if [ "$testing" = "0" ]
then
  res=2k
  drivers=amd

# q-main-pc
whiptail --yesno "Is this the main pc?" --title "Main PC?" --defaultno 10 40
main_pc=$?
clear

if [ "$main_pc" = "0" ]
then
  res=2k
  drivers=amd
fi

# q-resolution
if [ -z "$res" ]
then
        res=$(whiptail --title "Resolution" --notags --nocancel --menu "Select a resolution" 25 78 5 \
        "1080p" "1920x1080" \
        "ultrawide" "2560x1080" \
        "2k" "2560x1440" \
        "ultrawide2k" "3440x1440" \
        "4k" "3840x2160" 3>&1 1>&2 2>&3)
fi

# q-drivers
if [ -z "$drivers" ]
then
        drivers=$(whiptail --title "GPU Drivers" --notags --nocancel --menu "Select GPU drivers" 25 78 5 \
        "nvidia" "Nvidia" \
        "amd" "AMD" 3>&1 1>&2 2>&3)
fi

# q-poweroff/reboot
whiptail --yesno "What to do after the script?" --yes-button "poweroff" --no-button "reboot"  10 40
poweroff_q=$?
clear

# -------------- preperation --------------

# --- extra info :/ :{

# ---- functions ----

# to use sudo with functions (made by SebMa https://unix.stackexchange.com/users/135038/sebma with small modifications)
function fsudo {
        local firstArg=$1
        if [ $(type -t $firstArg) = function ]
        then
                shift && command sudo -E bash -c "$(declare -f $firstArg);$firstArg $*"
        elif [ $(type -t $firstArg) = alias ]
        then
                alias sudo='\sudo '
                eval "sudo $@"
        else
                command sudo -E "$@"
        fi
}

# to install packages
function install {
paru -S $@ --needed --noconfirm
}

# to move config files
function mvc {
mkdir -p $2
mv -f $HOME/dotfiles/$1 $2    # doesn't have teh variable because its with sudo (I don't know what i meant anymore)
}

# to have a more compact xdg-user-dirs :/
function xdg {
mkdir -p $2
xdg-user-dirs-update --set $1 $2
}

# to have a more compact librewolf addon setup
function addon {
wget https://addons.mozilla.org/firefox/downloads/file/$1/$2.xpi
mv $HOME/$2.xpi $HOME/$3.xpi
mv $HOME/$3.xpi $HOME/.librewolf/*.default-release/extensions/
}

# ---

# removing the need of a password during the script
echo '%wheel ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

# updating the system
sudo pacman -Syu --noconfirm

# installing packages needed for the script :/
sudo pacman -S git base-devel imagemagick --needed --noconfirm

# downloading xyz for later use :/
# dotfiles
git clone https://github.com/RyhoBtw/dotfiles
# scripts and pictures
git clone https://github.com/RyhoBtw/tmp-hola

# :( pacman
fsudo mvc pacman.conf /etc/

# updating pacman keyring
sudo pacman-key --populate archlinux

# moving go directory :/
export GOPATH="$XDG_DATA_HOME"/go

# installing paru
paru -Syu --noconfirm || { git clone https://aur.archlinux.org/paru-bin.git ; cd paru-bin ; makepkg -si --noconfirm ; sudo rm -r $HOME/paru-bin ;} || { git clone https://aur.archlinux.org/paru.git ; cd paru ; makepkg -si --noconfirm ; sudo rm -r $HOME/paru ;}
cd $HOME
paru -Syu --noconfirm

# Installing extra firmware to get rid of the warnings when installing packages :/
install mkinitcpio-firmware

# creating GnuPG directory to insure ever package gets installed properly :/
mkdir -p $HOME/.local/share/gnupg/

# -------------- setting up other stuff :/ --------------

# setting up xdg-user-dirs :/
install xdg-user-dirs
xdg DOWNLOAD $HOME/downloads
xdg PUBLICSHARE $HOME/misc/public
xdg DOCUMENTS $HOME/documents
xdg MUSIC $HOME/misc/music
xdg PICTURES $HOME/pictures
xdg VIDEOS $HOME/pictures/videos
xdg DESKTOP $HOME/misc/desktop
xdg TEMPLATES $HOME/documents/templates

# setting up scripts :/
install aria2
sudo cp $HOME/tmp-hola/scripts/* /opt/
ls -A1 $HOME/tmp-hola/scripts | xargs -i echo /opt/{} | xargs -L1 sudo chmod +x
cp -r $HOME/tmp-hola/scripts-pic $HOME/pictures

# setting up wallpapers :/
install feh
git clone https://gitlab.com/rhyo_/wallpaper.git $HOME/pictures/wallpaper
sudo rm -r $HOME/pictures/wallpaper/.git
mvc .fehbg $HOME
chmod +x $HOME/.fehbg

# -------------- setting up programms :/ --------------

# Installing python2
install python2-bin

# --security--
# ufw
install ufw
sudo systemctl enable ufw.service --now
sudo ufw allow VNC
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# changing bash-files location
# check all of this again :{
mv .bash_history $HOME/.cache/bash/
mv .bash_logout $HOME/.cache/bash/
mv .bash_profile $HOME/.config/bash/
mv .bashrc $HOME/.config/bash/

# Installing dash
install dash
sudo ln -sfT /bin/dash /bin/sh
fsudo mvc bash-update.hook /usr/share/libalpm/hooks/

# Installing zsh
install zsh thefuck --zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search zsh-theme-powerlevel10k-git
mkdir -p $HOME/.cache/zsh
mvc .zshenv $HOME
mvc .zshrc $HOME/.config/zsh
mvc .p10k.zsh $HOME/.config/zsh

# aliases
mvc aliasrc $HOME/.config

# picom setup
install picom-git
mvc picom.conf $HOME/.config/picom/

# alacritty config
install alacritty
mvc alacritty.yml $HOME/.config/alacritty/

# xorg setup
install xorg-server xorg-xinit

# awesome Setup
install awesome
mkdir -p $HOME/.config/awesome/
mvc rc.lua $HOME/.config/awesome
mvc mytheme.lua $HOME/.config/awesome
git clone https://github.com/Elv13/collision $HOME/.config/awesome/collision

# ---drivers setup---
# Nvidida setup
if [ $drivers = "nvidia" ]; then
        install nvidia nvidia-utils lib32-nvidia-utils nvidia-settings
	if [ "$testing" = "1" ]; then
		install gwe
		rc_num=$(grep -n polkit $HOME/.config/awesome/rc.lua | cut -d : -f1)
		rc_num=$(expr $rc_num + 1)
		perl -i -slpe 'print $s if $. == $n; $. = 0 if eof' -- -n=$rc_num -s='awful.spawn.with_shell("gwe --hide-window")' $HOME/.config/awesome/rc.lua*
		# Setting up script to run after next login
		cd /opt && sudo curl -LO https://raw.githubusercontent.com/RyhoBtw/archSh/main/first-boot.sh
		sudo chmod +x /opt/first-boot.sh
		echo '' >> $HOME/.config/awesome/rc.lua
		echo '-- First boot script' >> $HOME/.config/awesome/rc.lua
		echo 'awful.spawn.with_shell("alacritty -e /opt/first-boot.sh")' >> /$HOME/.config/awesome/rc.lua
		cd $HOME
	fi
fi

# AMD setup
if [ $drivers = "amd" ]; then
       install vulkan-radeon lib32-vulkan-radeon lib32-mesa xf86-video-amdgpu  		
fi

# Setup for testing
if [ "$testing" = "0" ]
then
	# sed -i -e 's/awful.spawn.with_shell("/opt/wm-program-check.sh")/-- &/' $HOME/.config/awesome/rc.lua
	sed -i -e 's/awful.spawn.with_shell("picom")/-- &/' $HOME/.config/awesome/rc.lua
        fsudo mvc 52-resolution-fix.conf /etc/X11/xorg.conf.d/
fi

# rofi setup
install rofi
mvc config.rasi $HOME/.config/rofi
mvc power.rasi $HOME/.config/rofi

# themes
install qogir-gtk-theme-git oxygen-cursors lxappearance
mvc settings.ini $HOME/.config/gtk-3.0
mvc .gtkrc-2.0 $HOME
mvc index.theme $HOME/.icons/default/

# installing SDDM
install sddm sddm-sugar-candy-git
sudo systemctl enable sddm.service
fsudo mvc sddm.conf /etc/sddm.conf.d/
fsudo mvc theme.conf /usr/share/sddm/themes/sugar-candy/
sudo cp $HOME/tmp-hola/pictures/sddm-paper-plane.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/

# theming grub
fsudo mvc grub /etc/default/
git clone https://github.com/vinceliuice/grub2-themes
cp $HOME/tmp-hola/pictures/grub-rocket-dark.jpg $HOME/grub2-themes/background.jpg
sudo $HOME/grub2-themes/install.sh -b -t whitesur -s $res -i white
sudo rm -r grub2-themes
sudo sed -i 's/, with Linux linux//g' /boot/grub/grub.cfg
install grub-customizer

# Installing fonts
install ttf-ms-fonts nerd-fonts-jetbrains-mono noto-fonts-cjk ttf-ancient-fonts fonts-noto-hinted terminus-font gnu-free-fonts ttf-liberation

# Setting up the printer
# install cups
# sudo systemctl enable --now cups
# sudo usermod -aG lp $USER
# install system-config-printer

# Setting up blueman
# install blueman
# systemctl start bluetooth.service

# Setting up redshift
install redshift-minimal
mvc redshift.conf $HOME/.config

# Setting up wget
mvc wgetrc $HOME/.config/wget

# Setting up timeshift
install timeshift
sudo mv $HOME/tmp-hola/scripts/timeshift-setup.sh /opt/
cd /opt
sudo curl -LO https://raw.githubusercontent.com/RhyoBtw/dotfiles/main/timeshift-setup.sh
sudo chmod +x /opt/timeshift-setup.sh
cd $HOME

# Setting up flameshot
install flameshot
mvc flameshot.ini $HOME/.config/flameshot

# Setting up audio
#install alsa-ucm-conf-git
#install pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber carla pavucontrol
#systemctl enable --user pipewire-pulse.service

# removing unwanted packages :{
#paru -R xterm xtermG i3 vim --noconfirm

# Installing packages
install libreoffice-fresh nemo signal-desktop polkit-gnome lf-bin exa htop tldr bat downgrade procs rsync man xdg-ninja exfat-utils fzf galculator btop arandr mpv peazip cups qbittorrent cbonsai cmatrix obsidian zip vscodium-bin ranger xterm stress lavat-git

# Setting up Neovim
install neovim vim-commentary neovim-surround vim-visual-multi neovim-nerdtree vim-devicons # vim-nerdtree-syntax-highlight nvim-packer-git :{
mvc init.lua $HOME/.config/nvim

# Setting up nsxiv
git clone https://github.com/nsxiv/nsxiv
cd $HOME/nsxiv
mvc config.h $HOME/nsxiv
sudo make install-all
cd $HOME
sudo rm -r $HOME/nsxiv

# networkmanager
install networkmanager
sudo systemctl enable NetworkManager.service --now

# setting up ripgrep
install ripgrep
mkdir -p $HOME/.config/ripgrep
touch $HOME/.config/ripgrep/ripgreprc

# setting up Librewolf
install librewolf-bin
librewolf --headless &
sleep 10
pkill -SIGTERM librewolf
# downloading addons
addon 3902154 decentraleyes-2.0.17 jid1-BoFifL9Vbdl2zQ@jetpack # decentraleyes
addon 3910598 canvasblocker-1.8 CanvasBlocker@kkapsner.de # canvasblocker
addon 3980848 clearurls-1.25.0 {74145f27-f039-47ce-a470-a662b129930a} # clear urls
addon 3993826 duckduckgo_for_firefox-2022.8.25 jid1-ZAdIEUB7XOzOJw@jetpack # duckduckgo
addon 4006940 sponsorblock-5.0.5 sponsorBlocker@ajay.app # sponsor block
addon 3449086 df_youtube-1.13.504 dfyoutube@example.com # df youtube
addon 4005382 return_youtube_dislikes-3.0.0.6 {762f9885-5a13-4abd-9c77-433dcd38b8fd} # return youtube dislikes
addon 4018008 bitwarden_password_manager-2022.10.1 {446900e4-71c2-419f-a6a7-df9c091e268b} # Bitwarden
# setting up addons
mvc extension-preferences.json $HOME/.librewolf/*.default-release/

# -------------- :( --------------

# remove script :/
sudo rm -r $HOME/tmp-hola
sudo rm -r $HOME/dotfiles
rm $HOME/archSh.sh

# possibly starting main-pc.sh :/
if [ "$main_pc" = "0" ]
then
        curl -LO https://raw.githubusercontent.com/RyhoBtw/archSh/main/main-pc.sh
        sh $HOME/main-pc.sh
fi

# adding the need for a passwd :/
sudo sed -i '$ d' /etc/sudoers

# :(
if [ "$poweroff_q" = "0" ]
then
        systemctl poweroff
else
        systemctl reboot
fi
