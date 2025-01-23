#!/usr/bin/env bash

sudo systemctl stop getty@tty1

LOGFILE="/home/zf/network_check.log"

log() {
    echo "[$(date)] $1" >> "$LOGFILE"
}

check_connection() {
    log "Checking network connection..."
    if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
        log "Network connection detected."
        return 0
    else
        log "No network connection."
        return 1
    fi
}

main() {
    # Show splash screen immediately
    feh --bg-center /home/zf/splash.png &

    # Wait up to 15 seconds for network connection
    for i in {1..30}; do
        if check_connection; then
            log "Network available. Exiting to allow startx service to proceed."
            pkill feh  # Kill the splash screen
            exit 0
        fi
        sleep 1
    done

    # No network connection after timeout
    log "No connection after timeout. Allowing autologin to present Wi-Fi setup."
    pkill feh  # Kill the splash screen
    sudo systemctl start getty@tty1
    exit 1
}

main