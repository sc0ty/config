#!/bin/bash

echo "export ICON_PATH=$PWD/icons" >> $HOME/.bashrc_local
echo ". $PWD/icons/zsh.sh" >> $HOME/.bashrc_local

which xseticon > /dev/null
if [[ $? != 0 ]]; then
	echo You must install xsection to use this - http://www.leonerd.org.uk/code/xseticon/
	echo Downloading...
	cd /tmp
	wget http://www.leonerd.org.uk/code/xseticon/xseticon-0.1+bzr13.tar.gz
	tar xzf xseticon-0.1+bzr13.tar.gz
	echo make and make install this
fi

