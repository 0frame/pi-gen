#!/usr/bin/env bash

# show a splash before browser kicks in
feh --bg-center /home/zf/splash.png

# check if a wifi.txt file exists in /boot/firmware, if so use the ssid and password values in it to connect to wifi,
# then delete the file. If not, proceed with this script.
if [ -f /boot/firmware/wifi.txt ]; then
    ssid=$(sed -n 1p /boot/firmware/wifi.txt)
	psk=$(sed -n 2p /boot/firmware/wifi.txt)
	if [ -n "$ssid" ] && [ -n "$psk" ]; then
		echo "Found wifi.txt file, connecting to wifi with ssid: $ssid" >> /home/zf/log.txt
		# use nmcli to connect to wifi, catching errors if the connection fails
        if nmcli device wifi connect "$ssid" password "$psk"; then
            echo "Connected to WiFi successfully." >> /home/zf/log.txt
		    rm /boot/firmware/wifi.txt
        else
            echo "Failed to connect to WiFi." >> /home/zf/log.txt
        fi
	else
		echo "SSID or password is missing in wifi.txt, skipping WiFi connection." >> /home/zf/log.txt
	fi
fi

pkill python
nohup python /home/zf/web/app.py > /home/zf/web/log.txt 2>&1 &


# # start the cec-client & browser
# (cec-client | cec2kbd) & browser --fullscreen "${URL:='https://0fra.me'}"

#######

# xscreensaver -no-splash

xset s off
xset -dpms
xset s noblank

unclutter -idle 0.1 &
matchbox-window-manager -use_cursor no &

# these seem to cause issues with video playback - removing resolved tearing
#--disable-gpu-memory-buffer-video-frames \
#--enable-features=VaapiVideoDecoder \
#--use-gl=egli \

exec /usr/bin/chromium \
	--noerrdialogs \
	--kiosk \
	--disable-infobars \
	--disable-extensions \
	--disable-bookmarks \
	--disable-features=TranslateUI \
	--disable-component-update \
	--disable-sync \
	--force-dark-mode \
	http://localhost:8080