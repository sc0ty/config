#!/bin/bash

cur=`ddcutil -t --sn MY3ND94P0F5T --sleep-multiplier=.2 getvcp 10 | grep 'VCP' | cut -d' ' -f 4`

if [ "$cur" = "10" ]; then
	python `dirname -- "$(readlink -f -- "$0";)"`/backlight.py 70
else
	notify-send --expire-time=3000 --transient --app-name=brightness --icon=/usr/share/icons/hicolor/48x48/status/display-brightness.png "Backlight: main screen only"
	ddcutil --noverify --sn MY3ND94P0F5T --sleep-multiplier=.2 setvcp 10 10
	ddcutil --noverify --sn 44580023 --sleep-multiplier=.2 setvcp 10 3
	ddcutil --noverify --sn J257M96B00FL --sleep-multiplier=.2 setvcp 10 0
fi
