#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

echo "Installing zsh..."
sudo pacman -S --needed --noconfirm zsh

echo "Linking zsh config..."
stow --dir="$DOTFILES_DIR" --target="$HOME" zsh

if [ ! -d "$ZINIT_HOME" ]; then
    echo "Installing zinit..."
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# .zshrc sources plugins straight from disk, so they must exist before first
# login. zinit installs them; it is not loaded at shell startup.
echo "Installing zsh plugins..."
TMUX=1 zsh -ic '
  source "$ZINIT_HOME/zinit.zsh"
  for p in romkatv/powerlevel10k zsh-users/zsh-completions Aloxaf/fzf-tab \
           zdharma-continuum/fast-syntax-highlighting zsh-users/zsh-autosuggestions; do
    zinit light "$p"
  done' || echo "warning: plugin install reported errors, check with: zi update --all"

echo "Setting zsh as default shell..."
sudo chsh -s "$(command -v zsh)" "$USER"

echo "zsh installed and configured!"
