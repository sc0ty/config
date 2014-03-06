#!/bin/sh

inst () {
	if [ ! -e "${HOME}/$1" ]
	then
		mv -n "${HOME}/$1" "${HOME}/backup/$1"
	fi
	ln -sf $2 "${PWD}/$1" "${HOME}/$1" 
}

mkdir -p "${HOME}/backup"

inst .vim
inst .vimrc -d
inst .bashrc
inst .tmux.conf

