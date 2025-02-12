#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Script names
SCRIPTS=(
    "001base.sh"
    "002pacmantweaks.sh"
    "003additional.sh"
    "004-1hyprland.sh"
    "004-2plasma.sh"
    "005software.sh"
    "006plymouth.sh"
)

# Script descriptions
DESCRIPTIONS=(
    "Base System Setup (updates, basic packages)"
    "Pacman Tweaks (multilib, mirrors, ParallelDownloads)"
    "AUR Setup (yay installation and packages)"
    "Hyprland Installation"
    "KDE Plasma Installation"
    "Software Installation"
    "Plymouth Setup"
)

# Print welcome message
print_welcome() {
    clear
    echo -e "${BOLD}Welcome to Arch Linux Setup Script${NC}"
    echo "This script will help you setup your Arch Linux installation"
    echo
    echo -e "${BLUE}Available steps:${NC}"
    for i in "${!DESCRIPTIONS[@]}"; do
        echo "$((i+1)). ${DESCRIPTIONS[$i]}"
    done
    echo
}

# Function to run a script
run_script() {
    local script_name=$1
    
    if [ -f "$script_name" ]; then
        echo -e "${BLUE}Running $script_name...${NC}"
        bash "$script_name"
        local exit_code=$?
        
        if [ $exit_code -eq 0 ]; then
            echo -e "${GREEN}$script_name completed successfully${NC}"
        else
            echo -e "${RED}$script_name failed with exit code $exit_code${NC}"
        fi
        
        echo
        read -p "Press Enter to continue..."
    else
        echo -e "${RED}Error: Script $script_name not found${NC}"
        return 1
    fi
}

# Main menu function
main_menu() {
    local selected=()
    
    # Initialize array for selected options
    for i in "${!SCRIPTS[@]}"; do
        selected[$i]=false
    done
    
    while true; do
        print_welcome
        
        # Show currently selected options
        echo -e "${BLUE}Selected steps:${NC}"
        for i in "${!SCRIPTS[@]}"; do
            if [ "${selected[$i]}" = true ]; then
                echo -e "${GREEN}✓ Step $((i+1)): ${DESCRIPTIONS[$i]}${NC}"
            fi
        done
        echo
        
        echo -e "${BOLD}Select an action:${NC}"
        echo "1-${#SCRIPTS[@]}: Toggle step selection"
        echo "r: Run selected steps"
        echo "a: Select all"
        echo "c: Clear selection"
        echo "q: Quit"
        echo
        read -p "Enter your choice: " choice
        
        case $choice in
            [1-9])
                if [ "$choice" -le "${#SCRIPTS[@]}" ]; then
                    selected[$((choice-1))]=$([ "${selected[$((choice-1))]}" = true ] && echo false || echo true)
                else
                    echo -e "${RED}Invalid option${NC}"
                    read -p "Press Enter to continue..."
                fi
                ;;
            r)
                local any_selected=false
                for i in "${!SCRIPTS[@]}"; do
                    if [ "${selected[$i]}" = true ]; then
                        any_selected=true
                        break
                    fi
                done
                
                if [ "$any_selected" = false ]; then
                    echo -e "${RED}No steps selected!${NC}"
                    read -p "Press Enter to continue..."
                    continue
                fi
                
                echo "Running selected scripts..."
                for i in "${!SCRIPTS[@]}"; do
                    if [ "${selected[$i]}" = true ]; then
                        run_script "${SCRIPTS[$i]}"
                    fi
                done
                ;;
            a)
                for i in "${!SCRIPTS[@]}"; do
                    selected[$i]=true
                done
                ;;
            c)
                for i in "${!SCRIPTS[@]}"; do
                    selected[$i]=false
                done
                ;;
            q)
                echo "Goodbye!"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Start the main menu
main_menu