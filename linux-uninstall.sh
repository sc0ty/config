#!/bin/bash
source ./functions.sh

echo "LINUX CONFIG:"
for conf in "${CONF_LINUX[@]}"; do
	restore "$conf"
done

which xterm &> /dev/null
if [ "$?" == "0" ]; then
	echo "XTERM CONFIG:"

	for conf in "${CONF_XTERM[@]}"; do
		restore "$conf"
	done

	for conf in "${CONF_LINUX_APPEND[@]}"; do
		restore_overwrite "$conf"
	done

	echo "  * merging resources"
	xrdb -merge ~/.Xresources
fi

if [ -n "$CYGWIN" ]; then
	echo "CYGWIN CONFIG:"

	for conf in "${CONF_CYGWIN[@]}"; do
		restore "$conf"
	done

	for conf in "${CONF_CYGWIN_APPEND[@]}"; do
		restore_overwrite "$conf"
	done
fi
