#!/bin/bash

set -e

echo "Installing JS dev tools..."

sudo pacman -S --needed --noconfirm \
    nodejs \
    npm \
    pnpm

echo "JS dev tools installed!"
