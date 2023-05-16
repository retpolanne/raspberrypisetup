#!/bin/bash

EXT_FILE=$1
DAEMONIZE=$2

if [ -z "$DAEMONIZE" ]; then 
	CONSOLE="console=ttyAMA0,115200"
else
	echo "Daemonizing"
	DAEMON="--daemonize"
fi


ls out/mnt && sudo umount out/mnt
mkdir -p out/mnt
MOUNT_OFFSET=$(fdisk -l $EXT_FILE | grep img1 | awk '{print $2 * 512}')
MOUNT_SIZE=$(fdisk -l $EXT_FILE | grep img1 | awk '{print $4 * 512}')
sudo mount -o offset=$MOUNT_OFFSET,sizelimit=$MOUNT_SIZE $EXT_FILE out/mnt 

qemu-img resize $EXT_FILE 2G
qemu-system-aarch64 \
    -M raspi3b \
    -cpu cortex-a72 \
    -append "rw earlyprintk loglevel=8 $CONSOLE dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" \
    -dtb out/mnt/bcm2710-rpi-3-b-plus.dtb \
    -sd  $EXT_FILE \
    -kernel out/mnt/kernel8.img \
    -m 1G -smp 4 \
    -nographic \
    $DAEMON \
    -usb -device usb-mouse -device usb-kbd \
        -device usb-net,netdev=net0 \
        -netdev user,id=net0,hostfwd=tcp::5555-:22
