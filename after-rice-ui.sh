paru -S steam


cd /opt && sudo curl -LO https://raw.githubusercontent.com/Prihler/umi/main/after-rice.sh
sudo chmod +x /opt/after-rice.sh
/opt/after-rice.sh &

sed -i "/after-rice-ui.sh/d" ~/.config/awesome/rc.lua
sudo rm /opt/after-rice-ui.sh
