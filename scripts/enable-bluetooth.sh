#!/bin/bash

set -e

echo "Enabling bluetooth..."

sudo pacman -S --needed --noconfirm bluez bluez-utils

sudo systemctl enable --now bluetooth.service

echo "Bluetooth enabled and started!"
