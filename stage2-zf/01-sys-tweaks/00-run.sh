#!/bin/bash -e
echo ">> Configuring Autologin"
install -m 644 files/etc/systemd/system/getty@tty1.service.d/autologin.conf "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/autologin.conf"