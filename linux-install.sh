#!/bin/sh

inst () {
	if [ ! -e "${HOME}/backup/$1" ]
	then
		mv -n "${HOME}/$1" "${HOME}/backup/$1"
	fi
	
	if [ -d "${PWD}/$1" ]
	then
		ln -sf "${PWD}/$1" "${HOME}/" 
	else
		ln -sf "${PWD}/$1" "${HOME}/$1" 
	fi
}

mkdir -p "${HOME}/backup"

inst .vim
inst .vimrc
inst .bashrc
inst .tmux.conf
inst .Xresources
xrdb -merge ~/.Xresources

