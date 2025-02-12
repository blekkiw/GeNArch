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

# Check for dracut
if pacman -Qi dracut &> /dev/null; then
    echo "Error: dracut detected. This script requires mkinitcpio"
    exit 1
fi

# Install plymouth
echo "Installing plymouth..."
if ! yay -S --needed plymouth; then
    echo "Error installing plymouth"
    exit 1
fi

# Add plymouth hook to mkinitcpio.conf if not present
echo "Configuring mkinitcpio..."
if ! grep -q "plymouth" /etc/mkinitcpio.conf; then
    # Add plymouth after consolefont/keymap
    sudo sed -i '/^HOOKS=/ s/\(consolefont \|keymap \)/\1plymouth /' /etc/mkinitcpio.conf
fi

# Check for bootloader type and configure kernel parameters
echo "Detecting boot configuration..."

add_kernel_params() {
    local current="$1"
    
    # Check if parameters are already present
    if [[ $current == *"quiet"* ]] && [[ $current == *"splash"* ]]; then
        return 1
    fi
    
    # Add only missing parameters
    local new_params="$current"
    [[ $current != *"quiet"* ]] && new_params="$new_params quiet"
    [[ $current != *"splash"* ]] && new_params="$new_params splash"
    
    echo "${new_params# }"  # Remove leading space if present
    return 0
}

# Function to update UKI parameters
update_uki_params() {
    local config_path="/etc/kernel/cmdline"
    if [ -f "$config_path" ]; then
        echo "Updating UKI kernel parameters..."
        local current_params
        current_params=$(cat "$config_path")
        
        if new_params=$(add_kernel_params "$current_params"); then
            echo "$new_params" | sudo tee "$config_path"
        fi
    fi
}

# Check and configure GRUB
if pacman -Qi grub &> /dev/null; then
    echo "GRUB detected, updating configuration..."
    if [ -f /etc/default/grub ]; then
        # Update GRUB_CMDLINE_LINUX_DEFAULT if needed
        current_params=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub | cut -d'"' -f2)
        if new_params=$(add_kernel_params "$current_params"); then
            sudo sed -i "s/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"$new_params\"/" /etc/default/grub
            # Update GRUB
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    fi
fi

# Check and configure systemd-boot
if pacman -Qi systemd-boot &> /dev/null || [ -d /boot/loader ]; then
    echo "systemd-boot detected, updating configuration..."
    for entry in /boot/loader/entries/*.conf; do
        if [ -f "$entry" ]; then
            current_params=$(grep "^options" "$entry" | cut -d' ' -f2-)
            if new_params=$(add_kernel_params "$current_params"); then
                sudo sed -i "s|^options.*|options $new_params|" "$entry"
            fi
        fi
    done
fi

# Check and update UKI parameters
if [ -d /etc/kernel ]; then
    update_uki_params
fi

# Rebuild initramfs
echo "Rebuilding initramfs..."
sudo mkinitcpio -P

echo "Plymouth installation and configuration completed successfully"
echo "Please reboot your system for changes to take effect"