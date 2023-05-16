#!/bin/bash

EXT_FILE=$1
DAEMONIZE=$2

[ "`uname -s | grep Darwin`" ] && PREFIX=/Volumes/bootfs/
if [ -z "$DAEMONIZE" ]; then 
	SERIAL="--serial stdio"
	CONSOLE="console=ttyAMA0,115200"
else
	echo "Daemonizing"
	DAEMON="--daemonize"
fi

ls /Volumes/bootfs/kernel8.img || { echo "Bootfs not mounted!"; exit 1; }

qemu-img resize $EXT_FILE 2G
qemu-system-aarch64 \
    -M raspi3b \
    -cpu cortex-a72 \
    -append "rw earlyprintk loglevel=8 $CONSOLE dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" \
    -dtb $PREFIX/bcm2710-rpi-3-b-plus.dtb \
    -sd  $EXT_FILE \
    -kernel $PREFIX/kernel8.img \
    -m 1G -smp 4 \
    $SERIAL \
    $DAEMON \
    -usb -device usb-mouse -device usb-kbd \
        -device usb-net,netdev=net0 \
        -netdev user,id=net0,hostfwd=tcp::5555-:22
