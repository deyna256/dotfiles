#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TPM_DIR="$HOME/.tmux/plugins/tpm"

echo "Installing tmux..."
sudo pacman -S --needed --noconfirm tmux

echo "Linking tmux config..."
stow --dir="$DOTFILES_DIR" --target="$HOME" tmux

if [ ! -d "$TPM_DIR" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "Installing tmux plugins..."
"$TPM_DIR/scripts/install_plugins.sh"

echo "tmux installed and configured!"
