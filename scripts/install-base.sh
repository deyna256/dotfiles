#!/bin/bash

set -e

echo "Installing base packages..."

sudo pacman -S --needed --noconfirm \
    base \
    base-devel \
    amd-ucode \
    git \
    less \
    stow

echo "Base packages installed!"

"$(dirname "$0")/configure-git.sh"
