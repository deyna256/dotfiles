#!/bin/bash

set -e

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
    echo "TPM is already installed"
    exit 0
fi

echo "Installing TPM..."
git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
echo "Done!"
