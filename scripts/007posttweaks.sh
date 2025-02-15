#!/bin/bash

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then
    echo "This script must not be run as root"
    exit 1
fi

# Check for required packages
for pkg in base sudo base-devel; do
    if ! pacman -Qi "$pkg" &> /dev/null; then
        echo "Missing required package: $pkg"
        exit 1
    fi
done

# Add default editor
if ! grep -q '^EDITOR' /etc/environment; then
    # Add editor to environment file
    sudo tee -a /etc/environment <<< "EDITOR=nano"
fi