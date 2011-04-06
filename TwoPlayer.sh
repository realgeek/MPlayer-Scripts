#!/bin/bash
# Try to start playing two files simultaneously with mplayer.
#####################################################################
# Copyright (C) 2011 Charlie Herron
# This code is released under the terms of the MIT/X license.
# Please see the file COPYING for more information.
#####################################################################
# Dependencies:
#   bash, sleep, grep, awk, MPlayer

# Adjust as necessary. This setting assumes a screen width of 1280:
x_midpoint=640
# A delay value of .18 works well on my MacBook2,1. You will almost certainly 
# need to tweak this for each system you run on.
delay='.18'
mpopts="-really-quiet -osdlevel 3"
mplog="/dev/null"

while [ "x$1" != 'x' ]; do
	if [ ${1:0:1} = '-' ]; then
		mpopts="$mpopts $1"
		shift
		continue
	else
		break
	fi
done
if [ "x$2" = 'x' ]; then
	echo "$0 needs two file arguments."
	exit 2
fi
f1width=`mplayer -vo null -ao null -frames 0 -identify "$1" 2>$mplog | \
  grep ID_VIDEO_WIDTH | \
  awk -F= '{print $2}'`
f1pos=$(( $x_midpoint - $f1width ))
if [ $f1pos -lt 0 ]; then
	f1pos=0
fi
sleep $delay && \
  mplayer $mpopts -geometry $f1pos:0 -slave "$1" >> $mplog 2>&1 &
mplayer $mpopts -geometry $x_midpoint:0 "$2" >> $mplog 2>&1

