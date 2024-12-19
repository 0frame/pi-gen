#!/bin/bash -e

. "${BASE_DIR}/config"
on_chroot << EOF
echo -n "${FIRST_USER_NAME:='pi'}:" > /boot/firmware/userconf.txt
openssl passwd -5 "${FIRST_USER_PASS:='raspberry'}" >> /boot/firmware/userconf.txt
touch /boot/firmware/ssh

echo "${KIOSK_URL}" > /boot/firmware/kiosk.url
chown 1000:1000 /boot/firmware/kiosk.url

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
export DEBIAN_FRONTEND=noninteractive
EOF

install -m 644 files/splash.png "${ROOTFS_DIR}/boot/splash.png"
# install zf service
install -m 644 files/zf.service "${ROOTFS_DIR}/etc/systemd/system/zf.service"
# install splash service
install -m 644 files/splash.service "${ROOTFS_DIR}/etc/systemd/system/splash.service"
on_chroot << EOF
    systemctl daemon-reload
    systemctl enable zf
    systemctl enable splash
EOF

install -m 644 files/cmdline.txt "${ROOTFS_DIR}/boot/firmware/"
install -m 644 files/config.txt "${ROOTFS_DIR}/boot/firmware/"

HOME="${ROOTFS_DIR}/home/${FIRST_USER_NAME}"
install -m 755 -o 1000 -g 1000 files/kiosk.sh "${HOME}/"
install -m 755 -o 1000 -g 1000 files/firstrun.sh "${HOME}/"
install -m 644 -o 1000 -g 1000 files/.profile "${HOME}/"
install -m 644 -o 1000 -g 1000 files/.xinitrc "${HOME}/"
install -m 644 -o 1000 -g 1000 files/.hushlogin "${HOME}/"
install -m 755 -o 1000 -g 1000 files/splash.png "${HOME}/"
install -m 755 -o 1000 -g 1000 -d "${HOME}/bin/"
install -m 755 -o 1000 -g 1000 files/bin/cec2kbd "${HOME}/bin/"
