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
on_chroot << EOF
    systemctl daemon-reload
    systemctl enable zf
    mkdir -p /var/lib/systemd/linger
    touch /var/lib/systemd/linger/${FIRST_USER_NAME}
EOF

install -m 644 files/cmdline.txt "${ROOTFS_DIR}/boot/firmware/"
install -m 644 files/config.txt "${ROOTFS_DIR}/boot/firmware/"

# Set some raspi-config stuff

on_chroot << EOF
    SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_change_locale en_US.UTF-8
    SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_blanking 1
    SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_serial_hw 1
    SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_serial_cons 1
EOF
# for now don't change boot behaviour to auto login since we are using a service
# raspi-config nonint do_boot_behaviour B2

HOME="${ROOTFS_DIR}/home/${FIRST_USER_NAME}"
install -m 755 -o 1000 -g 1000 files/kiosk.sh "${HOME}/"
# install -m 755 -o 1000 -g 1000 files/firstrun.sh "${HOME}/"
# install -m 644 -o 1000 -g 1000 files/.profile "${HOME}/"
install -m 755 -o 1000 -g 1000 files/.xinitrc "${HOME}/"
# install -m 644 -o 1000 -g 1000 files/.Xauthority "${HOME}/"
install -m 644 -o 1000 -g 1000 files/.hushlogin "${HOME}/"
install -m 755 -o 1000 -g 1000 files/splash.png "${HOME}/"

install -m 755 -o 1000 -g 1000 -d "${HOME}/bin/"
install -m 755 -o 1000 -g 1000 files/bin/cec2kbd "${HOME}/bin/"

install -m 755 -o 1000 -g 1000 -d "${HOME}/web/"
install -m 755 -o 1000 -g 1000 -d "${HOME}/web/static"
install -m 755 -o 1000 -g 1000 -d "${HOME}/web/static/res"
install -m 755 -o 1000 -g 1000 -d "${HOME}/web/templates"
install -m 755 -o 1000 -g 1000 files/web/app.py "${HOME}/web/"
install -m 755 -o 1000 -g 1000 files/web/static/res/logo-white.svg "${HOME}/web/static/res/"
install -m 755 -o 1000 -g 1000 files/web/templates/index.html "${HOME}/web/templates/"

install -m 644 files/Xwrapper.config "${ROOTFS_DIR}/etc/X11/"

on_chroot << EOF
    chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
EOF
