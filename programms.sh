#!/bin/sh

# Updating system
#paru -Syu --noconfirm

#paru -S discord bitwarden spotify github-desktop --noconfirm

# Installing KVM
#paru -S qemu libvirt virt-manager lxsession dnsmasq --noconfirm     #ebtables
#sudo systemctl enable libvirtd
#sudo usermod -G libvirt -a $USER
#echo 'sudo virsh net-start default' | sudo tee -a /opt/scripts/kvm-network.sh
#sudo chmod +x /opt/scripts/kvm-network.sh


#xrandr --output DVI-D-0 --off --output HDMI-0 --off --output DP-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-3 --off --output DP-4 --mode 1920x1080 --pos 3840x0 --rotate normal --output DP-5 --off

echo "Done"
sleep 10

rm programms.sh
