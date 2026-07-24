#!/bin/bash

set -e

echo "Installing C/C++ dev tools..."

sudo pacman -S --needed --noconfirm gcc

echo "C/C++ dev tools installed!"
