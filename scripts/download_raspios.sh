#!/bin/bash
echo "Getting latest raspios"

VER=`curl --silent https://downloads.raspberrypi.org/raspios_lite_arm64/images/ | grep -Po '(?<=href=\").*(?=\/")' | tail -1`
DATE=`echo $VER | grep -Po '[0-9]{4}-[0-9]{2}-[0-9]{2}'`
echo "Latest raspios is $VER"
FILE=`curl --silent -L https://downloads.raspberrypi.org/raspios_lite_arm64/images/$VER/ | grep -Po '"('$DATE'.*?)"' | tr -d '"' | head -1`
SHAFILE=`curl --silent -L https://downloads.raspberrypi.org/raspios_lite_arm64/images/$VER/ | grep -Po '"('$DATE'.*?)"' | tr -d '"' | grep sha256`
echo "Latest release file is $FILE"

EXT_FILE=`echo $FILE | cut -d . -f 1,2`
mkdir out
ls out/$EXT_FILE || wget https://downloads.raspberrypi.org/raspios_lite_arm64/images/$VER/$FILE -P out 
wget https://downloads.raspberrypi.org/raspios_lite_arm64/images/$VER/$SHAFILE -P out 

DL_SHA=`shasum -a 256 out/$FILE | awk '{print $1}'`
EXPECTED_SHA=`cat out/$SHAFILE | awk '{print $1}'`
[ "$DL_SHA" == "$EXPECTED_SHA" ] && \
	echo "shasum checked" && \
	xz -d -v out/$FILE || \
	echo "shasum failed! expected $EXPECTED_SHA - got $DL_SHA" #&& exit 1

