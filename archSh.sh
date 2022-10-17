#!/bin/sh

clear
cat <<'END'
                         _       ____    _     
   __ _   _ __    ___  | |__   / ___|  | |__  
  / _` | | '__|  / __| | '_ \  \___ \  | '_ \ 
 | (_| | | |    | (__  | | | |  ___) | | | | |
  \__,_| |_|     \___| |_| |_| |____/  |_| |_|
                                              
END
sleep 1
clear

# asking stuff

# q-testing
whiptail --yesno "Is this testing?" --title "Testig?" --defaultno 10 40
testing=$?
clear

if [ "$testing" = "0" ]
then
  res=1080p
  drivers=nvidia
fi

# q-main-pc
whiptail --yesno "Is this the main pc?" --title "Main PC?" --defaultno 10 40
main_pc=$?
clear

if [ "$main_pc" = "0" ]
then
  res=1080p
  drivers=nvidia
fi

# q-resolution
if [ -z "$res" ];
then
        res=$(whiptail --title "Resolution" --notags --nocancel --menu "Select a resolution" 25 78 5 \
        "1080p" "1920x1080" \
        "ultrawide" "2560x1080" \
        "2k" "2560x1440" \
        "ultrawide2k" "3440x1440" \
        "4k" "3840x2160" 3>&1 1>&2 2>&3)
fi

# q-drivers
if [ -z "$drivers" ];
then
        drivers=$(whiptail --title "GPU Drivers" --notags --nocancel --menu "Select GPU drivers" 25 78 5 \
        "nvidia" "Nvidia" \
        "amd" "AMD (unavailable)" 3>&1 1>&2 2>&3)
fi

# q-poweroff/reboot
whiptail --yesno "What to do after the script?" --yes-button "poweroff" --no-button "reboot"  10 40
poweroff_q=$?
clear

# --------------

# removing the need of a paswd during the script
echo '%wheel ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

# Updating system
sudo pacman -Syu --noconfirm

# Installing needed packages for the script
sudo pacman -S base-devel git imagemagick --needed --noconfirm
git clone https://gitlab.com/rhyo_/archsh-temp

# Updating pacman keyring
sudo pacman-key --populate archlinux

# xdg-user-dirs
sudo pacman -S xdg-user-dirs --noconfirm
mkdir $HOME/misc
mkdir $HOME/downloads
xdg-user-dirs-update --set DOWNLOAD $HOME/downloads
mkdir $HOME/misc/public
xdg-user-dirs-update --set PUBLICSHARE $HOME/misc/public
mkdir $HOME/documents
xdg-user-dirs-update --set DOCUMENTS $HOME/documents
mkdir $HOME/misc/music
xdg-user-dirs-update --set MUSIC $HOME/misc/music
mkdir $HOME/pictures
xdg-user-dirs-update --set PICTURES $HOME/pictures
mkdir $HOME/pictures/videos
xdg-user-dirs-update --set VIDEOS $HOME/pictures/videos
mkdir $HOME/misc/desktop
xdg-user-dirs-update --set DESKTOP $HOME/misc/desktop
mkdir $HOME/documents/templates
xdg-user-dirs-update --set TEMPLATES $HOME/documents/templates

# move go directroy
export GOPATH="$XDG_DATA_HOME"/go

# Installing Paru
paru -Syu || { git clone https://aur.archlinux.org/paru.git ; cd paru ; makepkg -si --noconfirm ; sudo rm -r $HOME/paru ;}

# Setting up pacman
sudo rm /etc/pacman.conf
cd /etc/
sudo curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/pacman.conf
cd /etc/

# idk
paru -Rdd atk --noconfirm
paru -S at-spi2-core --noconfirm

# Installing extra firmware
paru -S mkinitcpio-firmware --noconfirm

# --security--
# ufw
paru -S ufw --noconfirm
sudo systemctl enable ufw.service --now
sudo ufw allow VNC
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# etting up scripts
paru -S aria2 --noconfirm
cd /opt/
sudo curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/wm-program-check.sh
sudo chmod +x /opt/wm-program-check.sh
sudo curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/arch-iso.sh
sudo chmod +x /opt/arch-iso.sh
cd ~
mkdir ~/pictures/scripts-pic
cp ~/archSh-tmp/notify-arch.png ~/pictures/scripts-pic

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
sudo curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/bash-update.hook
cd ~

# Installing zsh
paru -S zsh thefuck zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search zsh-theme-powerlevel10k-git --noconfirm
mkdir -p ~/.cache/zsh
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/.zshenv
mkdir -p ~/.config/zsh/
cd ~/.config/zsh
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/.zshrc
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/.p10k.zsh
cd ~
# zsh plugins


# aliases
cd ~/.config
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/aliasrc
cd $HOME

# Installing doas

# picom setup
paru -S picom-git --noconfirm
mkdir $HOME/.config/picom
cd $HOME/.config/picom
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/picom.conf
cd $HOME

# Alacritty config & Picom
sudo pacman -S picom --noconfirm
mkdir -p ~/.config/alacritty/
cd ~/.config/alacritty/
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/alacritty.yml
cd $HOME

# xorg setup
paru -S xorg-server xorg-xinit --noconfirms

# Awesome Setup
paru -S awesome --noconfirm
#-----------
mkdir -p ~/.config/awesome/
cd ~/.config/awesome
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/rc.lua
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/mytheme.lua
git clone https://github.com/Elv13/collision
cd ~

# ---drivers setup---
# Nvidida setup
if [ $drivers = "nvidia" ]; then
        paru -S nvidia nvidia-utils lib32-nvidia-utils nvidia-settings --noconfirm
	if [ "$testing" = "1" ]; then
		paru -S gwe --noconfirm
		rc_num=$(grep -n polkit $HOME/.config/awesome/rc.lua | cut -d : -f1)
		rc_num=$(expr $rc_num + 1)
		perl -i -slpe 'print $s if $. == $n; $. = 0 if eof' -- -n=$rc_num -s='awful.spawn.with_shell("gwe --hide-window")' $HOME/.config/awesome/rc.lua*
	fi
fi

# AMD setup
if [ $drivers = "amd" ]; then
       paru -S xf86-video-amdgpu vulkan-radeon --noconfirm
fi

# rofi
paru -S rofi --noconfirm
mkdir ~/.config/rofi
cd ~/.config/rofi
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/config.rasi
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/power.rasi
cd ~

# Wallpaper
paru -S feh --noconfirm
git clone https://gitlab.com/rhyo_/wallpaper.git $HOME/pictures/wallpaper
sudo rm -r $HOME/pictures/wallpaper/.git
touch $HOME/.fehbg
echo '#!/bin/sh' >> $HOME/.fehbg
echo "feh --no-fehbg --bg-scale '/home/$USER/pictures/wallpaper/vector-style/landscape-stars-rockets-cold.jpg'" >> $HOME/.fehbg
chmod +x $HOME/.fehbg

# Themes
paru -S lxappearance --noconfirm
paru -S qogir-gtk-theme-git oxygen-cursors --noconfirm
mkdir $HOME/.config/gtk-3.0
cd $HOME/.config/gtk-3.0
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/settings.ini
cd $HOME
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/.gtkrc-2.0
mkdir -p $HOME/.icons/default/
cd $HOME/.icons/default/
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/index.theme
cd $HOME


# Installing SDDM
paru -S sddm sddm-sugar-candy-git --noconfirm
sudo systemctl enable sddm.service
sudo mkdir /etc/sddm.conf.d/
cd /etc/sddm.conf.d/
sudo curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/sddm.conf
sudo cp ~/ifums-tmp/sddm-paper-plane.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/
cd /usr/share/sddm/themes/sugar-candy/
sudo rm /usr/share/sddm/themes/sugar-candy/theme.conf
sudo curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/theme.conf
cd $HOME

# Theming Grub
sudo rm /etc/default/grub
cd /etc/default/
sudo curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/grub
cd $HOME
git clone https://github.com/vinceliuice/grub2-themes
cp ~/ifums-tmp/grub-rocket-dark.jpg ~/grub2-themes/background.jpg
sudo ~/grub2-themes/install.sh -b -t whitesur -s 1080p -i white
sudo rm -r grub2-themes
sudo sed -i 's/, with Linux linux//g' /boot/grub/grub.cfg
paru -S grub-customizer --noconfirm

# Installing fonts
paru -S ttf-ms-fonts nerd-fonts-jetbrains-mono noto-fonts-cjk ttf-ancient-fonts fonts-noto-hinted terminus-font gnu-free-fonts ttf-liberation --noconfirm

# Setting up the printer
#paru -S cups
#sudo systemctl enable --now cups
#sudo usermod -aG lp $USER
#paru -S system-config-printer

# Setting up redshift
paru -S redshift-minimal --noconfirms
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/redshift.conf --output-dir $HOME/.config

# Setting up wget
mkdir $HOME/.config/wget
cd $HOME/.config/wget
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/wgetrc
cd $HOME

# Setting up timeshift
paru -S timeshift --noconfirm
cd /opt
sudo curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/timeshift-setup.sh
sudo chmod +x /opt/timeshift-setup.sh
cd $HOME

# Setting up audio
#paru -S pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumbe alsa-ucm-conf-git carla --noconfirm
#systemctl enable --user pipewire-pulse.service

# creating GnuPG directory
mkdir $HOME/.local/share/gnupg/

# removing unwanted packages
#paru -R xterm xtermG i3 nano vim --noconfirm

# Installing packages
#paru -S librewolf-bin libreoffice-fresh --noconfirm
paru -S librewolf-bin libreoffice-fresh nemo signal-desktop solaar vscodium-bin polkit-gnome lf-bin exa htop networkmanager nsxiv tldr bat downgrade ripgrep procs rsync flameshot man xdg-ninja exfat-utils fzf galculator btop redshift-minimal arandr mpv peazip cups qbittorrent cbonsai cmatrix obsidian zip --noconfirm

# Setting up Neovim
paru -S neovim vim-commentary neovim-surround vim-visual-multi --noconfirm
paru -S neovim-nerdtree vim-devicons --noconfirm
# vim-nerdtree-syntax-highlight nvim-packer-git
mkdir .config/nvim
cd $HOME/.config/nvim
curl -LO https://raw.githubusercontent.com/RyhoBtw/dotfiles/main/init.lua
cd $HOME

# networkmanager
sudo systemctl enable NetworkManager.service --now

# Setting up ripgrep
mkdir $HOME/.config/ripgrep
touch $HOME/.config/ripgrep/ripgreprc

# Setting up Librewolf
librewolf --headless &
sleep 10
pkill -SIGTERM librewolf
# Downloading addons
# decntraleyes
wget https://addons.mozilla.org/firefox/downloads/file/3902154/decentraleyes-2.0.17.xpi
mv $HOME/decentraleyes-2.0.17.xpi $HOME/jid1-BoFifL9Vbdl2zQ@jetpack.xpi
mv $HOME/jid1-BoFifL9Vbdl2zQ@jetpack.xpi $HOME/.librewolf/*.default-release/extensions/
# canvasblocker
wget https://addons.mozilla.org/firefox/downloads/file/3910598/canvasblocker-1.8.xpi
mv $HOME/canvasblocker-1.8.xpi $HOME/CanvasBlocker@kkapsner.de.xpi
mv $HOME/CanvasBlocker@kkapsner.de.xpi $HOME/.librewolf/*.default-release/extensions/
# clear urls
wget https://addons.mozilla.org/firefox/downloads/file/3980848/clearurls-1.25.0.xpi
mv $HOME/clearurls-1.25.0.xpi $HOME/{74145f27-f039-47ce-a470-a662b129930a}.xpi
mv $HOME/{74145f27-f039-47ce-a470-a662b129930a}.xpi $HOME/.librewolf/*.default-release/extensions/
# user-agent switcher
wget https://addons.mozilla.org/firefox/downloads/file/3952467/user_agent_string_switcher-0.4.8.xpi
mv $HOME/user_agent_string_switcher-0.4.8.xpi $HOME/{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}.xpi
mv $HOME/{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}.xpi $HOME/.librewolf/*.default-release/extensions/
# duckduckgo
wget https://addons.mozilla.org/firefox/downloads/file/3993826/duckduckgo_for_firefox-2022.8.25.xpi
mv $HOME/duckduckgo_for_firefox-2022.8.25.xpi $HOME/jid1-ZAdIEUB7XOzOJw@jetpack.xpi
mv $HOME/jid1-ZAdIEUB7XOzOJw@jetpack.xpi $HOME/.librewolf/*.default-release/extensions/
# sponsor block
wget https://addons.mozilla.org/firefox/downloads/file/4006940/sponsorblock-5.0.5.xpi
mv $HOME/sponsorblock-5.0.5.xpi $HOME/sponsorBlocker@ajay.app.xpi
mv $HOME/sponsorBlocker@ajay.app.xpi $HOME/.librewolf/*.default-release/extensions/
# df youtube
wget https://addons.mozilla.org/firefox/downloads/file/3449086/df_youtube-1.13.504.xpi
mv $HOME/df_youtube-1.13.504.xpi $HOME/dfyoutube@example.com.xpi
mv $HOME/dfyoutube@example.com.xpi $HOME/.librewolf/*.default-release/extensions/
# return youtube dislikes
wget https://addons.mozilla.org/firefox/downloads/file/4005382/return_youtube_dislikes-3.0.0.6.xpi
mv $HOME/return_youtube_dislikes-3.0.0.6.xpi $HOME/{762f9885-5a13-4abd-9c77-433dcd38b8fd}.xpi
mv $HOME/{762f9885-5a13-4abd-9c77-433dcd38b8fd}.xpi $HOME/.librewolf/*.default-release/extensions/

# remove script
sudo rm -r ~/archSh-tmp
rm archSh.sh

# possibly starting main-pc.sh
if [ "$main_pc" = "0" ]
then
        curl -LO https://raw.githubusercontent.com/Prihler/ifums/main/main-pc.sh
        sh $HOME/main-pc.sh
fi

# adding the need for a passwd
sudo sed -i '$ d' /etc/sudoers

if [ "$poweroff_q" = "0" ]
then
        systemctl poweroff
else
        systemctl reboot
fi
