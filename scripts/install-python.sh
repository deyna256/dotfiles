#!/bin/bash

set -e

echo "Installing Python dev tools..."

sudo pacman -S --needed --noconfirm \
    python \
    ruff \
    ty \
    uv

echo "Python dev tools installed!"
