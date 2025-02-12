#!/bin/bash

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then
    echo "This script must not be run as root"
    exit 1
fi

# Check for required packages
for pkg in base sudo git yay; do
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

# Clone and install Hyprland
echo "Cloning JaKooLit's Hyprland installer..."
if [ -d "$HOME/Arch-Hyprland" ]; then
    echo "Arch-Hyprland directory already exists. Removing..."
    rm -rf "$HOME/Arch-Hyprland"
fi

git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git "$HOME/Arch-Hyprland"
cd "$HOME/Arch-Hyprland" || exit 1
chmod +x install.sh

echo "Starting Hyprland installation..."
./install.sh

# Install additional packages
echo "Installing additional packages..."
# Replace with your packages
aur_packages=(
    xorg-xhost
    kate
    xdg-desktop-portal
    xdg-desktop-portal-hyprlandc
    shared-mime-info
    xdg-utils
    okular
    gwenview
)

if ! yay -S --needed "${aur_packages[@]}"; then
    echo "Error installing additional packages"
    exit 1
fi

echo "Installation completed successfully"