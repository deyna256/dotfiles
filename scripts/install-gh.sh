#!/bin/bash

set -e

echo "Installing GitHub CLI..."

sudo pacman -S --needed --noconfirm github-cli

echo "GitHub CLI installed!"
