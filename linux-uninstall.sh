#!/bin/sh

uninst () {
	if [ -L "${HOME}/$1" ]
	then
		rm -f "${HOME}/$1"
	fi

	if [ -e "./backup/$1" ]
	then
		mv -n "./backup/$1" "${HOME}/$1" 
	fi
}

uninst .vim
uninst .vimrc
uninst .bashrc
uninst .zshrc
uninst .tmux.conf
uninst .Xresources
xrdb -merge ~/.Xresources

