#!/bin/bash

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then
    echo "This script must not be run as root"
    exit 1
fi

# Check for required packages
for pkg in base sudo reflector; do
    if ! pacman -Qi "$pkg" &> /dev/null; then
        echo "Missing required package: $pkg"
        exit 1
    fi
done

# Enable multilib if disabled
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i '/^#\[multilib\]/{
        s/^#//
        n
        s/^#//
    }' /etc/pacman.conf
fi

# Ask for country
read -p "Enter your country for mirror selection: " country
echo "Updating mirrorlist for $country..."
if ! sudo reflector --verbose --country "$country" -l 25 --sort rate --save /etc/pacman.d/mirrorlist; then
    echo "Error updating mirrorlist"
    exit 1
fi

# Configure pacman
echo "Configuring pacman..."
# Enable ParallelDownloads if commented
if grep -q '^#ParallelDownloads' /etc/pacman.conf; then
    sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
fi

# Enable Colors if commented
if grep -q '^#Color' /etc/pacman.conf; then
    sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
fi

# Add ILoveCandy if not present
if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
    # Add after any existing Misc options line
    sudo sed -i '/^# Misc options/a ILoveCandy' /etc/pacman.conf
fi

# System update
echo "Updating system..."
if ! sudo pacman -Syu --needed; then
    echo "Error updating system"
    exit 1
fi

echo "Tweaks completed successfully"