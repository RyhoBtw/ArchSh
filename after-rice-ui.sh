# Installing steam
paru -S steam

# stasrting the second part of the script
cd /opt && sudo curl -LO https://raw.githubusercontent.com/Prihler/umi/main/after-rice.sh
sudo chmod +x /opt/after-rice.sh
/opt/after-rice.sh &

# removing the script
sed -i "/after-rice-ui.sh/d" ~/.config/awesome/rc.lua
sudo rm /opt/after-rice-ui.sh
