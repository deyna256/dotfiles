#!/bin/bash

set -e

echo "Installing GNOME desktop..."

sudo pacman -S --needed --noconfirm \
    gdm \
    gnome-shell \
    gnome-session \
    gnome-settings-daemon \
    gnome-control-center \
    gnome-keyring \
    gnome-tweaks \
    gnome-calculator \
    gnome-disk-utility \
    gnome-system-monitor \
    xdg-desktop-portal-gnome \
    xdg-desktop-portal-gtk \
    xdg-utils \
    python-gobject \
    libnotify \
    networkmanager \
    iwd \
    pipewire-pulse \
    pavucontrol \
    power-profiles-daemon \
    brightnessctl

echo "Enabling services..."
sudo systemctl enable --now gdm.service NetworkManager.service power-profiles-daemon.service

echo "GNOME desktop installed!"
