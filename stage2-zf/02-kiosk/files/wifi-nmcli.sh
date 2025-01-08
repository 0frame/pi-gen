#!/bin/bash

# Function to check for active network connection
check_connection() {
    if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
        return 0
    else
        return 1
    fi
}

# Main script execution
while true; do
    echo "Checking network connection..."

    if check_connection; then
        echo "Network is connected."
        break
    else
        echo "No connection. Configuring network using nmcli..."
        nmcli device wifi list
        read -p "Enter SSID: " ssid
        read -sp "Enter password: " password
        echo
        nmcli device wifi connect "$ssid" password "$password"
    fi
done

echo "Starting X server..."
startx
