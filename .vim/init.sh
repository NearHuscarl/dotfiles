#!/bin/bash

function join_path {
	local os=$(uname -s)

	if [[ "$os" =~ 'CYGWIN' ]]; then
		local first_path=$(echo "$1" | sed 's/\//\\/g')
		local second_path=$(echo "$2" | sed 's/\//\\/g')
		echo ""$first_path"\\"$second_path""
	else
		local first_path=$(echo "$1" | sed 's/\\/\//g')
		local second_path=$(echo "$2" | sed 's/\\/\//g')
		echo ""$first_path"/"$second_path""
	fi
}


os=$(uname -s)

if [[ "$os" =~ 'CYGWIN' ]]; then
	vim_path=$(join_path "$USERPROFILE" 'vimfiles')
elif [[ "$os" == 'Linux' ]]; then
	vim_path=$(join_path "$HOME" '.vim')
fi
vim_plug_path=$(join_path "$vim_path" 'autoload/plug.vim')
dir_list="plugged session swapfiles undo"

# Make necessary directories if not exists
for dir in $dir_list; do
	if [[ ! -d "$vim_path"/"$dir" ]]; then
		mkdir -p "$vim_path"/"$dir"
	fi
done

# Download plug.vim if not exists
if [[ ! -s "$vim_plug_path" ]]; then
	echo 'Downloading plug.vim..'
	curl -o "$vim_plug_path" "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi
