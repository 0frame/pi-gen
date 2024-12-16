#!/bin/bash -e
echo ">> Configuring Autologin"
mkdir -p "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d"
install -m 644 files/etc/systemd/system/getty@tty1.service.d/autologin.conf "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/autologin.conf"