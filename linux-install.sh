#!/bin/sh
mkdir -p "${HOME}/backup"
mkdir -p "${HOME}/backup/mc"

mv -n "${HOME}/.vim" "${HOME}/backup/.vim"
mv -n "${HOME}/.vimrc" "${HOME}/backup/.vimrc"
mv -n "${HOME}/.bashrc" "${HOME}/backup/.bashrc"
mv -n "${HOME}/.config/mc/ini" "${HOME}/backup/mc/ini"

ln -sd "${PWD}/.vim/" "${HOME}/" 
ln -s "${PWD}/.vimrc" "${HOME}/.vimrc" 
ln -s "${PWD}/.bashrc" "${HOME}/.bashrc" 
ln -s "${PWD}/mc/ini" "${HOME}/.config/mc/ini" 

