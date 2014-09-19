#!/bin/sh
source ./../functions.sh

MC_VERSION=mc-4.8.13

evalcmd pact update
evalcmd pact install libglib2.0-devel libslang-devel

evalorexit wget http://ftp.midnight-commander.org/${MC_VERSION}.tar.xz
evalorexit tar xfJ ${MC_VERSION}.tar.xz

evalorexit cd ${MC_VERSION}
evalorexit ./configure --enable-vfs-smb
evalorexit make $@

evalcmd pact remove mc
evalorexit make install

