#!/bin/sh

#xrandr --output DP-0 --mode 1920x1080 --pos 0x0 --output DP-2 --primary --mode 1920x1080 --pos 1920x0 --output DP-4 --mode 1920x1080 --pos 3840x0

# Updating system
paru -Syu --noconfirm

paru -S discord bitwarden spotify github-desktop --noconfirm

# Installing KVM
paru -S qemu libvirt virt-manager lxsession dnsmasq --noconfirm     #ebtables
sudo systemctl enable libvirtd
sudo usermod -G libvirt -a $USER
echo 'sudo virsh net-start default' | sudo tee -a /opt/scripts/kvm-network.sh
sudo chmod +x /opt/scripts/kvm-network.sh

rm programms.sh
