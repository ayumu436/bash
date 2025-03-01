#!/bin/bash

LOG_FILE="/var/log/linuxoptimizer.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check if running inside Docker
is_docker() {
    [[ -f /.dockerenv ]]
}

# Function to clean junk files
clean_junk() {
    log "Starting junk file cleanup..."

    # Handle different package managers
    if command -v pacman &>/dev/null; then
        sudo pacman -Sc --noconfirm
    elif command -v apt &>/dev/null; then
        sudo apt autoremove -y && sudo apt clean
    elif command -v dnf &>/dev/null; then
        sudo dnf autoremove -y && sudo dnf clean all
    elif command -v zypper &>/dev/null; then
        sudo zypper clean --all
    else
        log "No supported package manager found. Skipping package cleanup."
    fi

    # Clean journal logs if `journalctl` exists
    if command -v journalctl &>/dev/null; then
        sudo journalctl --vacuum-time=7d
    else
        log "Skipping journal cleanup (journalctl not found)"
    fi

    log "Junk file cleanup completed."
}

# Function to optimize RAM
optimize_ram() {
    log "Optimizing RAM usage..."

    if is_docker; then
        log "Skipping RAM optimization (running inside Docker)"
        return
    fi

    echo 3 | sudo tee /proc/sys/vm/drop_caches

    if swapon --summary | grep -q "swap"; then
        sudo swapoff -a && sudo swapon -a
    else
        log "No swap file found, skipping swap optimization."
    fi

    log "RAM optimization completed."
}

# Function to optimize CPU
optimize_cpu() {
    log "Optimizing CPU usage..."

    if is_docker; then
        log "Skipping CPU optimization (running inside Docker)"
        return
    fi

    # Stop unnecessary services
    SERVICES=("bluetooth.service" "cups.service" "avahi-daemon.service" "ModemManager.service")

    for SERVICE in "${SERVICES[@]}"; do
        if command -v systemctl &>/dev/null; then
            if systemctl list-units --type=service --all | grep -q "$SERVICE"; then
                sudo systemctl stop "$SERVICE"
                log "Stopped $SERVICE"
            else
                log "Skipping $SERVICE (not installed)."
            fi
        else
            log "Skipping service optimizations (systemctl not found)"
            break
        fi
    done

    log "CPU optimization completed."
}

# Function to enable scheduled optimization
enable_scheduled_optimization() {
    log "Enabling scheduled optimization..."
    
    if is_docker; then
        log "Skipping scheduled optimization (running inside Docker)"
        return
    fi

    CRON_JOB="0 3 * * * /bin/bash $0 4"
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    log "Scheduled optimization enabled (Runs daily at 3 AM)."
}

# Function to disable scheduled optimization
disable_scheduled_optimization() {
    log "Disabling scheduled optimization..."
    
    if is_docker; then
        log "Skipping scheduled optimization (running inside Docker)"
        return
    fi

    crontab -l 2>/dev/null | grep -v "$0" | crontab -
    log "Scheduled optimization disabled."
}

# Main Menu
while true; do
    clear
    echo "Linux System Optimizer - Pro Version"
    echo "1. Clean Junk Files"
    echo "2. Optimize RAM"
    echo "3. Optimize CPU"
    echo "4. Run All Optimizations"
    echo "5. Enable Scheduled Optimization"
    echo "6. Disable Scheduled Optimization"
    echo "7. Exit"
    read -p "Choose an option: " option

    case $option in
        1) clean_junk ;;
        2) optimize_ram ;;
        3) optimize_cpu ;;
        4)
            clean_junk
            optimize_ram
            optimize_cpu
            ;;
        5) enable_scheduled_optimization ;;
        6) disable_scheduled_optimization ;;
        7) log "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please select a valid number." ;;
    esac

    read -p "Press Enter to continue..."
done
