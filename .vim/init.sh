#!/bin/bash

vimPath="$HOME/.vim"
dirList="undo swapfiles session plugged"

# Make necessary directories if not exists
for dir in $dirList; do
   if [ ! -d $vimPath/$dir ]; then
      mkdir -p $vimPath/$dir
   fi
done

# Download plug.vim if not exists
if [ ! -s ~/.vim/autoload/plug.vim ]; then
   wget  -O ~/.vim/autoload/plug.vim "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi
