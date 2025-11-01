#!/bin/bash

set -e

echo "Enabling bluetooth..."

sudo pacman -S --needed --noconfirm bluez bluez-utils

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

echo "Bluetooth enabled and started!"
