#!/bin/bash

set -e

PACKAGES_FILE="${1:-packages.txt}"

if ! command -v yay &> /dev/null; then
    echo "Error: yay is not installed"
    exit 1
fi

if [ ! -f "$PACKAGES_FILE" ]; then
    echo "Error: File '$PACKAGES_FILE' not found"
    exit 1
fi

echo "Installing packages from: $PACKAGES_FILE"

while IFS= read -r line; do
    line=$(echo "$line" | xargs)
    if [[ -n "$line" && ! "$line" =~ ^# ]]; then
        echo "Installing: $line"
        yay -S --needed --noconfirm "$line"
    fi
done < "$PACKAGES_FILE"

echo "Done!"
