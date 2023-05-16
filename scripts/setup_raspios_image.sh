#!/bin/bash

if [ "`uname -s | grep Darwin`" ]; then
	CUR_DATE=`date '+%Y%m%d'`
	echo "Running the darwin implementation that relies on qemu"
	LATEST_IMG=`ls -t out/*.img | head -1`
	ls out/mnt/boot && echo "SD card is mounted" || { echo "SD card not mounted!"; exit 1; }
	# TODO - enable SSH and add authorized keys
	# Use ssh keygen?
	ls $HOME/.ssh/raspberrypi || mkdir $HOME/.ssh/raspberrypi
	ssh-keygen -t ed25519 -C "raspberrypi" -f ~/.ssh/raspberrypi/$CUR_DATE-raspios-ssh -N ""
	mkdir -p out/mnt/home/pi/.ssh
	cat $HOME/.ssh/raspberrypi/$CUR_DATE-raspios-ssh.pub > out/mnt/home/pi/.ssh/authorized_keys
	chmod 700 out/mnt/home/pi/.ssh && chmod 600 out/mnt/home/pi/.ssh/authorized_keys
	echo "Key generated under $HOME/.ssh/raspberrypi/$CUR_DATE-raspios-ssh"
	#./scripts/raspios_qemu.sh $LATEST_IMG true
	./scripts/raspios_qemu.sh $LATEST_IMG
fi
