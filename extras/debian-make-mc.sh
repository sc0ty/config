#!/bin/sh
source ./../functions.sh

evalcmd sudo apt-get update
evalcmd sudo apt-get build-dep mc
evalorexit apt-get source mc

evalorexit cd mc-*
evalorexit ./configure --enable-vfs-smb --enable-vfs-undelfs
evalorexit make $@

evalcmd sudo apt-get purge mc
evalorexit sudo make install

