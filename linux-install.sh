#!/bin/sh
mkdir -p "${HOME}/backup"

mv -n "${HOME}/.vim" "${HOME}/backup/.vim"
mv -n "${HOME}/.vimrc" "${HOME}/backup/.vimrc"
mv -n "${HOME}/.bashrc" "${HOME}/backup/.bashrc"

ln -sd "${PWD}/.vim/" "${HOME}/" 
ln -s "${PWD}/.vimrc" "${HOME}/.vimrc" 
ln -s "${PWD}/.bashrc" "${HOME}/.bashrc" 

