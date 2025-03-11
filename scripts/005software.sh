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

# Install additional packages
echo "Installing additional packages..."
# Replace with your packages
aur_packages=(
    google-chrome
    keepassxc
    thunderbird
    intellij-idea-ultimate-edition 
    dbeaver
    fastfetch
    filezilla
    tree
    xclip
    spotify-launcher
    slack-desktop-wayland 
    telegram-desktop 
    chatbox-bin
    maven
    jdk-openjdk
    openjdk-doc
    openjdk-src
    openjdk11-src 
    openjdk11-doc 
    openjdk17-src 
    openjdk17-doc 
    openjdk21-src 
    openjdk21-doc 
    openjdk8-src 
    openjdk8-doc
    timeshift
    ark
    docker-desktop
    kate
    steam
    filelight
    gimp
    krita
    htop
    mc
    okular
    gwenview
    ktorrent
    isoimagewriter
    gparted
    libreoffice-still
    lutris
    postman-bin
    discord
    vlc
    zoom
    syncthing
    ufw
    percona-server-clients
)

if ! yay -S --needed "${aur_packages[@]}"; then
    echo "Error installing additional packages"
    exit 1
fi

systemctl enable --now --user syncthing

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

echo "Installation completed successfully"