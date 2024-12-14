#!/usr/bin/env bash

# read URL from easily accessible location
URL=$(head -n 1 /boot/kiosk.url)

# never blank the screen
# xset s off -dpms

# rotate to portrait mounted TV
# xrandr --output HDMI-1 --rotate left

# xrandr --output HDMI-1

# show a splash before browser kicks in
feh --bg-scale splash.png

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
  "${URL:='https://0fra.me'}"