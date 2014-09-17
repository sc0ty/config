#!/bin/sh


CONF_LINUX=(.vim .vimrc .bashrc .zshrc .tmux.conf)
CONF_XTERM=(.Xresources)

CONF_CYGWIN=(.minttyrc)
CONF_CYGWIN_APPEND=(.bashrc_local)
DIR_CYGWIN="cygwin"


backup () {
	if [ ! -e "./backup/$1" ] && [ -e "${HOME}/$1" ]; then
		echo "  * backing up $1"

		mkdir -p "./backup"
		mv -n "${HOME}/$1" "./backup/$1"
	fi
}

backup_cp() {
	if [ ! -e "./backup/$1" ] && [ -e "${HOME}/$1" ]; then
		echo "  * backing up $1  [CP]"
		cp "${HOME}/$1" "./backup/"
	fi
}

install () {
	src="$1"
	dst="$1"
	if [ -n "$2" ] ; then
		src="$2/$1"
	fi


	if [ -d "${PWD}/${src}" ]; then
		echo "  * installing ${src} to ${dst}  [DIR]"
		ln -sf "${PWD}/${src}" "${HOME}/"
	else
		echo "  * installing ${src} to ${dst}"
		ln -sf "${PWD}/${src}" "${HOME}/${dst}"
	fi
}

install_append () {
	src="$1"
	dst="$1"
	if [ -n "$2" ] ; then
		src="$2/$1"
	fi

	echo "  * installing ${src} to ${dst}  [APPEND]"
	cat "${PWD}/${src}" >> "${HOME}/${dst}"
}

restore () {
	if [ -e "./backup/$1" ]; then
		echo "  * restoring $1"

		if [ -L "${HOME}/$1" ]; then
			rm -f "${HOME}/$1"
		fi
		mv -n "./backup/$1" "${HOME}/$1" 
	fi
}

restore_overwrite() {
	if [ -e "./backup/$1" ]; then
		echo "  * restoring $1 [OVERWRITE]"

		if [ -L "${HOME}/$1" ]; then
			rm -f "${HOME}/$1"
		fi
		mv -f "./backup/$1" "${HOME}/$1" 
	fi
}

