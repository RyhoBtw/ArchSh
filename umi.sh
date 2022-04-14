#!/bin/bash

sudo pacman -Syu --noconfirm

sudo pacman -S base-devel --needed --noconfirm
sudo pacman -S git --noconfirm

#Installing Paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..
