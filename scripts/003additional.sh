#!/bin/bash

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then
    echo "This script must not be run as root"
    exit 1
fi

# Check for required packages
for pkg in base sudo git base-devel; do
    if ! pacman -Qi "$pkg" &> /dev/null; then
        echo "Missing required package: $pkg"
        exit 1
    fi
done

# Update system
echo "Updating system..."
if ! sudo pacman -Syu --needed; then
    echo "Error updating system"
    exit 1
fi

# Check if yay is already installed
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    # Create temporary directory and clone yay
    temp_dir=$(mktemp -d)
    cd "$temp_dir" || exit 1
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    makepkg -si --needed --noconfirm
    cd "$HOME" || exit 1
    rm -rf "$temp_dir"
else
    echo "yay is already installed"
fi

# Install linux-headers for installed kernels
echo "Installing linux-headers for detected kernels..."
# Get list of installed linux kernels
kernel_packages=(linux linux-zen linux-lts linux-hardened)
headers_packages=()

# Check which kernels are installed and add their headers
for kernel in "${kernel_packages[@]}"; do
    if pacman -Qi "$kernel" &> /dev/null; then
        headers_packages+=("$kernel-headers")
    fi
done

# Install headers if any kernels were found
if [ ${#headers_packages[@]} -gt 0 ]; then
    echo "Installing headers: ${headers_packages[*]}"
    if ! sudo pacman -S --needed "${headers_packages[@]}"; then
        echo "Error installing kernel headers"
        exit 1
    fi
else
    echo "No Linux kernels found. This is unusual and might indicate a problem."
    exit 1
fi

# Install AUR packages
echo "Installing AUR packages..."

# Replace with your packages
aur_packages=(
    libwnck3
    mesa-utils
    xf86-input-libinput
    xorg-xdpyinfo
    xorg-server
    xorg-xinit
    xorg-xinput
    xorg-xkill
    xorg-xrandr
    b43-fwcutter
    broadcom-wl-dkms
    dnsmasq
    dnsutils
    ethtool
    modemmanager
    networkmanager-openconnect
    networkmanager-openvpn
    nss-mdns
    openssh
    usb_modeswitch
    xl2tpd
    pacman-contrib
    pkgfile
    rebuild-detector
    reflector
    accountsservice
    bash-completion
    bluez
    bluez-utils
    ffmpegthumbnailer
    gst-libav
    gst-plugin-pipewire
    gst-plugins-bad
    gst-plugins-ugly
    libdvdcss
    libgsf
    libopenraw
    plocate
    poppler-glib
    xdg-user-dirs
    xdg-utils
    haveged
    nfs-utils
    nilfs-utils
    ntp
    smartmontools
    unrar
    unzip
    xz
    lrzip
    unace
    p7zip
    squashfs-tools
    cantarell-fonts
    freetype2
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    noto-fonts-extra
    ttf-bitstream-vera
    ttf-dejavu
    ttf-liberation
    ttf-opensans
    alsa-firmware
    alsa-plugins
    alsa-utils
    pavucontrol
    pipewire-pulse
    wireplumber
    pipewire-alsa
    pipewire-jack
    rtkit
    dmidecode
    dmraid
    hdparm
    hwdetect
    lsscsi
    mtools
    sg3_utils
    sof-firmware
    power-profiles-daemon
    upower
    duf
    findutils
    glances
    hwinfo
    inxi
    meld
    nano-syntax-highlighting
    pv
    python-defusedxml
    python-packaging
    rsync
    tldr
    sed
    vi
    wget
    aspell
    firewalld
    python-pyqt5
    python-capng
    cups
    cups-browsed
    cups-filters
    cups-pdf
    foomatic-db
    foomatic-db-engine
    foomatic-db-gutenprint-ppds
    foomatic-db-nonfree
    foomatic-db-nonfree-ppds
    foomatic-db-ppds
    ghostscript
    gsfonts
    gutenprint
    splix
    system-config-printer
    hplip
    python-pillow
    python-pyqt5
    python-reportlab
    sane
    intel-ucode
    amd-ucode
)

if ! yay -S --needed "${aur_packages[@]}"; then
    echo "Error installing AUR packages"
    exit 1
fi

echo "Installation completed successfully"