# Updating system
paru -Syu --noconfirm

# Installing VM
paru -S qemu libvirt virt-manager lxsession dnsmashq --noconfirm     #ebtables
sudo systemctl enable libvirtd
sudo usermod -G libvirt -a $USER
