# Updating system
paru -Syu --noconfirm

# Installing VM
paru -S qemu libvirt virt-manager lxsession dnsmashq --noconfirm     #ebtables
sudo systemctl enable libvirtd
sudo usermod -G libvirt -a $USER
#sudo touch /opt/scripts/kvm-network.sh
#echo -e 'sudo virsh net-start default' >> /opt/kvm-network.sh
