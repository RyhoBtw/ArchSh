#!/bin/sh
#sudo sed -i 's/^#MAKEFLAGS=.*/MAKEFLAGS="-j256"/g' /etc/makepkg.conf

# Setting up steam
paru -S steam
paru -S protonup-qt --noconfirm

# Nvidia settings
sudo nvidia-settings

# Setting up Discord
echo 'awful.spawn.with_shell("discord")' >> /$HOME/.config/awesome/rc.lua

# removing the script
sed -i "/after-rice.sh/d" ~/.config/awesome/rc.lua
sudo rm /opt/after-rice.sh

# Librewolf addons
librewolf --new-tab addons.mozilla.org/en-US/firefox/addon/decentraleyes/ &
sleep 5
librewolf addons.mozilla.org/en-US/firefox/addon/clearurls/ &
librewolf addons.mozilla.org/en-US/firefox/addon/return-youtube-dislikes/ &
librewolf addons.mozilla.org/en-US/firefox/addon/sponsorblock/ &
librewolf addons.mozilla.org/en-US/firefox/addon/canvasblocker/
librewolf addons.mozilla.org/en-US/firefox/addon/canvasblocker/
