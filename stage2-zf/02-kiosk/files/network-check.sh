#!/bin/bash

# Function to check if the device has an active network connection
check_connection() {
    if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
        return 0  # Connection exists
    else
        return 1  # No connection
    fi
}

# Function to run nmtui for network setup
run_nmtui() {
    echo "Launching nmtui for network setup..."
    nmtui
}

on_success() {
    echo "[] Network setup complete. Launching Zeroframe!"
    /usr/bin/startx
}
# Main script execution
while true; do
    echo "Checking network connection..."

    if check_connection; then
        on_success
        break
    else
        echo "No network connection detected."
        echo "Starting network configuration..."
        run_nmtui

        echo "Rechecking network connection..."
        if check_connection; then
            on_success
            break
        else
            echo "Still no network connection."
            read -p "Do you want to retry setting up the network? (y/n): " retry
            if [[ "$retry" != "y" ]]; then
                echo "Exiting script without network connection."
                exit 1
            fi
        fi
    fi

done

# Continue with the rest of your script here
# echo "Network setup complete. Proceeding with the script..."
# Add your script's next steps below
on_success
