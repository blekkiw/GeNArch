#!/bin/bash

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then
    echo "This script must not be run as root"
    exit 1
fi

# Check for required packages
for pkg in base sudo yay; do
    if ! pacman -Qi "$pkg" &> /dev/null; then
        echo "Missing required package: $pkg"
        exit 1
    fi
done

# System update
echo "Updating system..."
if ! yay -Syu --needed; then
    echo "Error updating system"
    exit 1
fi

# Install Plasma and essential KDE applications
echo "Installing KDE Plasma and essential packages..."

# Basic Plasma desktop
plasma_packages=(
    sddm                      # Display manager
    plasma
    konsole                   # Terminal emulator
    dolphin                   # File manager
    dolphin-plugins           # Additional file manager features
    spectacle                 # Screenshot tool
    ark                       # Archive manager
    kate                      # Text editor
    xdg-desktop-portal-kde    # XDG desktop portal
    xdg-desktop-portal       # XDG desktop portal (required for KDE)
    xdg-utils
    kde-gtk-config           # GTK apps configuration
    kio                    # KDE Input/Output library
    kdialog                # KDE dialog boxes
)

# Additional useful packages
additional_packages=(
    yakuake                  # Drop-down terminal
)

echo "Installing Plasma packages..."
if ! yay -S --needed "${plasma_packages[@]}" "${additional_packages[@]}"; then
    echo "Error installing Plasma packages"
    exit 1
fi

# Enable SDDM
echo "Enabling SDDM service..."
sudo systemctl enable sddm

echo "Plasma installation completed successfully"
echo "Reboot your system to load the new desktop environment"