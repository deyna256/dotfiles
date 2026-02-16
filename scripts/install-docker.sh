#!/bin/sh

sudo pacman -S --needed docker docker-compose docker-buildx

sudo systemctl enable --now docker

sudo usermod -aG docker "$USER"
