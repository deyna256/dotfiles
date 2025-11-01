#!/bin/bash

set -e

if command -v yay &> /dev/null; then
    echo "yay is already installed"
    exit 0
fi

echo "Installing yay..."

sudo pacman -S --needed --noconfirm git base-devel

cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

cd ..
rm -rf yay

echo "yay installed successfully!"
