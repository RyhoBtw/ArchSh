#!/bin/sh

#xrandr --output DP-0 --mode 1920x1080 --pos 0x0 --rate 74.97 --output DP-2 --primary --mode 1920x1080 --pos 1920x0 --rate 144 --output DP-4 --mode 1920x1080 --pos 3840x0 --rate 74.97

# Updating system
paru -Syu --noconfirm

paru -S etcher-bin gimp bitwarden spotify nvidia-settings --noconfirm

# Installing Discord
paru -S discord --noconfirm
echo 'awful.spawn.with_shell("discord")' >> /$HOME/.config/awesome/rc.lua

# Installing GitHub
paru -S github-desktop --noconfirm
mkdir /$HOME/documents/github

# Installing KVM
paru -S qemu libvirt virt-manager lxsession dnsmasq --noconfirm     #ebtables
sudo systemctl enable libvirtd
sudo usermod -G libvirt -a $USER
echo 'sudo virsh net-start default' | sudo tee -a /opt/kvm-network.sh
sudo chmod +x /opt/kvm-network.sh

# monitor setup
echo 'awful.spawn.with_shell("xrandr --output DP-0 --mode 1920x1080 --pos 0x0 --rate 74.97 --output DP-2 --primary --mode 1920x1080 --pos 1920x0 --rate 144 --output DP-4 --mode 1920x1080 --pos 3840x0 --rate 74.97")' >> /$HOME/.config/awesome/rc.lua

# Wake on lan
#paru -S wol-systemd --noconfirm
#sudo systemctl enable wol@enp39s0
#sudo systemctl start wol@enp39s0

# ssh
#paru -S openssh --noconfirm
#sudo systemctl enable sshd.service
#sudo systemctl start sshd.service

# Setting up script to run after next login
cd /opt && sudo curl -LO https://raw.githubusercontent.com/Prihler/umi/main/after-rice.sh
sudo chmod +x /opt/after-rice.sh
echo 'awful.spawn.with_shell("/opt/after-rice.sh")' >> /$HOME/.config/awesome/rc.lua
#echo 'awful.spawn.with_shell("alacritty -e /opt/after-rice.sh")' >> /$HOME/.config/awesome/rc.lua

rm $HOME/programms.sh
