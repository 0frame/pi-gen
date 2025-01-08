#!/usr/bin/env bash

check_connection() {
    if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
        return 0 # Connection exists
    else
        return 1 # No connection
    fi
}

if check_connection; then
    # read URL from easily accessible location
    URL=$(head -n 1 /boot/firmware/kiosk.url)

    # never blank the screen
    # xset s off -dpms

    # rotate to portrait mounted TV
    # xrandr --output HDMI-1 --rotate left

    # xrandr --output HDMI-1

    # show a splash before browser kicks in
    feh --bg-center /home/zf/splash.png

    # # start the cec-client & browser
    # (cec-client | cec2kbd) & browser --fullscreen "${URL:='https://0fra.me'}"

    #######

    xscreensaver -no-splash

    xset s off
    xset -dpms
    xset s noblank

    unclutter -idle 0.1 &
    matchbox-window-manager -use_cursor no &

    exec /usr/bin/chromium \
        --noerrdialogs \
        --kiosk \
        --disable-infobars \
        --disable-extensions \
        --disable-bookmarks \
        --disable-features=TranslateUI \
        --disable-component-update \
        --disable-sync \
        --disable-gpu-memory-buffer-video-frames \
        --enable-features=VaapiVideoDecoder \
        --use-gl=egli \
        --force-dark-mode \
        "${URL:='https://0fra.me'}"
    break
else
    echo "[] No network connection detected, booting into network setup..."
    exit 1
fi
