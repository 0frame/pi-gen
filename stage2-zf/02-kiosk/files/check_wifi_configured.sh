#!/usr/bin/env bash

# Check for saved Wi-Fi configurations - not necessarily connected
check_wifi_config() {
    if nmcli connection show | grep -q "wifi"; then
        echo "Wi-Fi connection(s) configured."
        return 0
    else
        echo "No Wi-Fi connections configured."
        return 1
    fi
}

exit check_wifi_config
