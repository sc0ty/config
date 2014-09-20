#!/bin/bash
source ./../functions.sh

evalcmd mkdir -p "${HOME}/bin"
evalorexit wget http://www.paralint.com/projects/notifu/dl/notifu-1.6.zip
evalorexit unzip notifu-1.6.zip notifu.exe -d "${HOME}/bin"
evalcmd chmod a+x "${HOME}/bin/notifu.exe"
evalorexit ln -s "${PWD}/../cygwin/notify-send" "${HOME}/bin/notify-send"

