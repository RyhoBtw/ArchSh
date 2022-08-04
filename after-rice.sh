#!/bin/sh

# Installing steam
paru -S steam
paru -S protonup-qt --noconfirm

# Nvidia settings
sudo nvidia-settings

# Setting up Discord
echo 'awful.spawn.with_shell("discord")' >> /$HOME/.config/awesome/rc.lua
discord

# Librewolf addons
librewolf --new-tab addons.mozilla.org/en-US/firefox/addon/decentraleyes/ &
librewolf --new-tab addons.mozilla.org/en-US/firefox/addon/clearurls/ &
librewolf --new-tab addons.mozilla.org/en-US/firefox/addon/return-youtube-dislikes/ &
librewolf --new-tab addons.mozilla.org/en-US/firefox/addon/sponsorblock/ &

# removing the script
sed -i "/after-rice.sh/d" ~/.config/awesome/rc.lua
sudo rm /opt/after-rice.sh
