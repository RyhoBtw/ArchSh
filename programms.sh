#!/bin/sh

# Updating system
paru -Syu --noconfirm

paru -S discord --noconfirm

# Installing VM
paru -S qemu libvirt virt-manager lxsession dnsmashq --noconfirm     #ebtables
sudo systemctl enable libvirtd
sudo usermod -G libvirt -a $USER
echo 'sudo virsh net-start default' | sudo tee -a /opt/scripts/kvm-network.sh
