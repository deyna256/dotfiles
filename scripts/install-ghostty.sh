#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Installing ghostty..."
# The Nerd Font variant is required: powerlevel10k's glyphs live there, and
# without it fontconfig substitutes a different Nerd font at another width.
sudo pacman -S --needed --noconfirm ghostty ttf-jetbrains-mono ttf-jetbrains-mono-nerd

echo "Linking ghostty config..."
stow --dir="$DOTFILES_DIR" --target="$HOME" ghostty

echo "Validating config..."
ghostty +validate-config

echo "ghostty installed and configured!"
