#!/bin/sh
source ./functions.sh

echo "LINUX CONFIG:"
for conf in "${CONF_LINUX[@]}"; do
	backup "$conf"
	install "$conf"
done

which xterm &> /dev/null
if [ "$?" == "0" ]; then
	echo "XTERM CONFIG:"

	for conf in "${CONF_XTERM[@]}"; do
		backup "$conf"
		install "$conf"
	done

	echo "  * merging resources"
	xrdb -merge ~/.Xresources
fi

if [ -n "$CYGWIN" ]; then
	echo "CYGWIN CONFIG:"

	for conf in "${CONF_CYGWIN[@]}"; do
		backup "$conf"
		install "$conf" "$DIR_CYGWIN"
	done

	for conf in "${CONF_CYGWIN_APPEND[@]}"; do
		backup_cp "$conf"
		install_append_existing "$conf" "$DIR_CYGWIN"
	done
fi

