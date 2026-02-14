#!/usr/bin/env bash

# show a splash before browser kicks in
feh --bg-center /home/zf/splash.png

# check if a wifi.txt file exists in /boot/firmware, if so use the ssid and password values in it to connect to wifi,
# then delete the file. If not, proceed with this script.
LOG=/home/zf/log.txt
WIFI_FILE=/boot/firmware/wifi.txt

if [ -f "$WIFI_FILE" ]; then
  ssid="$(sed -n '1p' "$WIFI_FILE" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  psk="$(sed -n '2p' "$WIFI_FILE" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

  if [ -n "$ssid" ] && [ -n "$psk" ]; then
    echo "$(date) Found wifi.txt, attempting connect to SSID: [$ssid]" >> "$LOG"

    # diagnostics
    sudo nmcli -t -f RUNNING general >> "$LOG" 2>&1
    sudo nmcli -t -f WIFI-HW,WIFI,WWAN-HW,WWAN radio >> "$LOG" 2>&1
    sudo nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device status >> "$LOG" 2>&1
    sudo rfkill list >> "$LOG" 2>&1 || true
    ip link show wlan0 >> "$LOG" 2>&1 || true

    # wait for wlan0 to be present and not "unavailable/unmanaged"
    for i in {1..30}; do
      state="$(nmcli -t -f DEVICE,STATE dev status | awk -F: '$1=="wlan0"{print $2}')"
      echo "$(date) wlan0 state: ${state:-missing}" >> "$LOG"
      [ -n "$state" ] && [ "$state" != "unavailable" ] && [ "$state" != "unmanaged" ] && break
      sleep 1
    done

    sudo nmcli dev set wlan0 managed yes >> "$LOG" 2>&1 || true
    sudo ip link set wlan0 up >> "$LOG" 2>&1 || true

    # optional scan log
    sudo nmcli dev wifi rescan ifname wlan0 >> "$LOG" 2>&1 || true
    sleep 3
    sudo nmcli -f IN-USE,SSID,SIGNAL dev wifi list ifname wlan0 | head -n 50 >> "$LOG" 2>&1 || true

    # connect via profile (more reliable than "device wifi connect" at boot)
    sudo nmcli con add type wifi ifname wlan0 con-name "zf-wifi" ssid "$ssid" >> "$LOG" 2>&1 || true
    sudo nmcli con modify "zf-wifi" wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$psk" >> "$LOG" 2>&1
    if sudo nmcli -w 30 con up "zf-wifi" >> "$LOG" 2>&1; then
      echo "$(date) Connected successfully." >> "$LOG"
      rm -f "$WIFI_FILE"
    else
      rc=$?
      echo "$(date) Failed to connect (exit $rc)." >> "$LOG"
      sudo journalctl -u NetworkManager -n 80 --no-pager >> "$LOG" 2>&1 || true
    fi
  else
    echo "$(date) SSID or password missing in wifi.txt; skipping." >> "$LOG"
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