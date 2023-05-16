#!/bin/bash

LINUX_DISKS=`diskutil list | grep Linux | awk '{print $5}'`

for disk in $LINUX_DISKS; do
	DISK=${disk::${#disk}-2}
	diskutil unmountDisk /dev/$DISK
	diskutil eject /dev/$DISK
done
