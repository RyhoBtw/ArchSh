#!/bin/sh

librewolf --headless

# Installing steam
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


notify-send "Setup done"

# removing the script
sudo rm /opt/after-rice.sh
