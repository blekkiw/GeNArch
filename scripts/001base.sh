#!/bin/bash

# root check
if [ "$EUID" -eq 0 ]; then
    echo "This script must NOT be run as root"
    exit 1
fi

# Check for minimum packages base & sudo
for pkg in base sudo; do
    if ! pacman -Qi "$pkg" &> /dev/null; then
        echo "Missing package: $pkg"
        exit 1
    fi
done

# Update system
echo "Updating system..."
if ! sudo pacman -Syu --needed; then
    echo "Error updating system"
    exit 1
fi

# Package list
echo "Installing base packages..."
# add or remove packages as needed
packages=(
       archlinux-keyring
       base-devel
       curl
       diffutils
       dosfstools
       e2fsprogs
       exfatprogs
       f2fs-tools
       git
       go
       iptables-nft
       inetutils
       jfsutils
       less
       logrotate
       lsb-release
       lvm2
       man-db
       man-pages
       mdadm
       nano
       ntfs-3g
       perl
       python
       rsync
       reflector
       sysfsutils
       systemd-sysvcompat
       texinfo
       usbutils
       which
       xfsprogs
       xterm
)

if ! sudo pacman -S --needed "${packages[@]}"; then
    echo "Error installing packages"
    exit 1
fi

echo "Done!"