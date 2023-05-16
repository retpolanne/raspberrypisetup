#!/bin/bash

EXT_FILE=$1
echo "Mounting raspios image"

ls out/mnt && sudo umount out/mnt
mkdir -p out/mnt

MOUNT_OFFSET=$(fdisk -l $EXT_FILE | grep img2 | awk '{print $2 * 512}')
MOUNT_SIZE=$(fdisk -l $EXT_FILE | grep img2 | awk '{print $4 * 512}')
sudo mount -o offset=$MOUNT_OFFSET,sizelimit=$MOUNT_SIZE $EXT_FILE out/mnt 

ls out/mnt/bin && echo "SD card mounted!" || { echo "Didn't mount sd card!"; exit 1; }

echo "Generating SSH key for raspberry"
CUR_DATE=`date '+%Y%m%d'`
ls $HOME/.ssh/raspberrypi || mkdir $HOME/.ssh/raspberrypi
ssh-keygen -t ed25519 -C "raspberrypi" -f ~/.ssh/raspberrypi/$CUR_DATE-raspios-ssh -N ""
mkdir -p out/mnt/home/pi/.ssh
cat $HOME/.ssh/raspberrypi/$CUR_DATE-raspios-ssh.pub > out/mnt/home/pi/.ssh/authorized_keys
chmod 700 out/mnt/home/pi/.ssh && chmod 600 out/mnt/home/pi/.ssh/authorized_keys
echo "Key generated under $HOME/.ssh/raspberrypi/$CUR_DATE-raspios-ssh"

#sudo umount out/mnt
