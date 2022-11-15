#!/bin/sh
#sudo sed -i 's/^#MAKEFLAGS=.*/MAKEFLAGS="-j256"/g' /etc/makepkg.conf

# Nvidia settings
sudo nvidia-settings

# removing the script
sed -i "$(( $(wc -l <$HOME/.config/awesome/rc.lua)-3+1 )),$ d" $HOME/.config/awesome/rc.lua
sudo rm /opt/first-boot.sh
