#!/usr/bin/env bash

echo "[] Setting up Zeroframe Player"

# echo
# echo ">> Enabling Read-Only Overlay File System"
# sudo raspi-config nonint enable_overlayfs
# sudo raspi-config nonint enable_bootro
sudo raspi-config nonint do_change_locale en_US.UTF-8
sudo raspi-config nonint do_boot_splash 1
sudo raspi-config nonint do_boot_behaviour B2
sudo raspi-config nonint do_blanking 1
sudo raspi-config nonint memory_split 512
sudo raspi-config nonint do_serial_hw 1
sudo raspi-config nonint do_serial_cons 1

echo
# echo ">> Removing First Run Script"
rm ./firstrun.sh

echo
echo "[] Rebooting"
sudo reboot
