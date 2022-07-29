#!/bin/sh

# Installing steam
paru -S steam



# removing the script
sed -i "/after-rice.sh/d" ~/.config/awesome/rc.lua
sudo rm /opt/after-rice.sh
