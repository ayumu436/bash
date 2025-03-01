#!/bin/bash

# Linux System Optimizer - Pro Version
# Author: Yoshiki

LOG_FILE="/var/log/boostlinux.log"

# Define colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Error: This script must be run as root.${RESET}"
    exit 1
fi

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check if a systemd service exists before disabling it
disable_service() {
    if systemctl list-units --type=service --all | grep -q "$1"; then
        systemctl disable "$1"
        log_action "Disabled $1 service."
    else
        log_action "Skipping $1 service (not installed)."
    fi
}

# Function to clean junk files
clean_junk() {
    log_action "Starting junk file cleanup..."
    echo -e "${YELLOW}Cleaning junk files...${RESET}"

    if command -v apt &>/dev/null; then
        apt autoremove -y && apt autoclean -y
    elif command -v pacman &>/dev/null; then
        ORPHANS=$(pacman -Qdtq)
        if [[ -n "$ORPHANS" ]]; then
            pacman -Rns $ORPHANS --noconfirm
        else
            echo -e "${GREEN}No orphaned packages to remove.${RESET}"
        fi
        pacman -Sc --noconfirm
    elif command -v dnf &>/dev/null; then
        dnf autoremove -y && dnf clean all
    elif command -v zypper &>/dev/null; then
        zypper clean --all
    fi

    journalctl --vacuum-time=3d

    log_action "Junk file cleanup completed."
    echo -e "${GREEN}Junk files cleaned successfully!${RESET}"
}

# Function to optimize RAM
optimize_ram() {
    log_action "Optimizing RAM..."
    echo -e "${YELLOW}Optimizing RAM usage...${RESET}"
    sync && echo 3 > /proc/sys/vm/drop_caches
    swapoff -a && swapon -a
    log_action "RAM optimization completed."
    echo -e "${GREEN}RAM optimization complete!${RESET}"
}

# Function to optimize CPU
optimize_cpu() {
    log_action "Optimizing CPU..."
    echo -e "${YELLOW}Optimizing CPU usage...${RESET}"

    disable_service "bluetooth.service"
    disable_service "cups.service"
    disable_service "avahi-daemon.service"
    disable_service "ModemManager.service"

    log_action "CPU optimization completed."
    echo -e "${GREEN}CPU optimization complete!${RESET}"
}

# Function to enable automatic optimization
schedule_optimization() {
    log_action "Scheduling system optimization..."
    echo -e "${CYAN}Scheduling daily system optimization at 3 AM...${RESET}"
    (crontab -l 2>/dev/null; echo "0 3 * * * /usr/bin/bash $(realpath $0) --auto") | crontab -
    log_action "System optimization scheduled."
    echo -e "${GREEN}Scheduled optimization successfully enabled!${RESET}"
}

# Function to remove scheduled optimization
remove_schedule() {
    log_action "Removing scheduled system optimization..."
    crontab -l | grep -v "$(realpath $0) --auto" | crontab -
    log_action "Scheduled optimization removed."
    echo -e "${GREEN}Scheduled optimization disabled.${RESET}"
}

# Function to display the menu
show_menu() {
    echo -e "${CYAN}Linux System Optimizer - Pro Version${RESET}"
    echo "1. Clean Junk Files"
    echo "2. Optimize RAM"
    echo "3. Optimize CPU"
    echo "4. Run All Optimizations"
    echo "5. Enable Scheduled Optimization"
    echo "6. Disable Scheduled Optimization"
    echo "7. Exit"
    read -p "Choose an option: " choice
    case $choice in
        1) clean_junk ;;
        2) optimize_ram ;;
        3) optimize_cpu ;;
        4) clean_junk && optimize_ram && optimize_cpu ;;
        5) schedule_optimization ;;
        6) remove_schedule ;;
        7) exit ;;
        *) echo -e "${RED}Invalid option!${RESET}" ;;
    esac
}

# Auto-run mode for scheduled execution
if [[ "$1" == "--auto" ]]; then
    clean_junk && optimize_ram && optimize_cpu
    exit 0
fi

# Run menu
show_menu
