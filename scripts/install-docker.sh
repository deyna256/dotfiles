#!/bin/bash

set -e

echo "Installing Docker..."

sudo pacman -S --needed --noconfirm docker docker-compose docker-buildx

sudo systemctl enable --now docker.service

sudo usermod -aG docker "$USER"

echo "Docker installed! Log out and back in for group membership to take effect."
