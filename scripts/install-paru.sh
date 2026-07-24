#!/bin/bash

set -e

if command -v paru &> /dev/null; then
    echo "paru is already installed"
    exit 0
fi

echo "Installing paru..."

BUILD_DIR="$(mktemp -d)"
git clone https://aur.archlinux.org/paru.git "$BUILD_DIR"
(cd "$BUILD_DIR" && makepkg -si --noconfirm)
rm -rf "$BUILD_DIR"

echo "paru installed!"
