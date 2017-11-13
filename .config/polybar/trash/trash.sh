#!/bin/bash

trash_dir=""$HOME"/.local/share/Trash/"

paren_dir="$(dirname "$(readlink -f "$0")")"

case ${1:-print} in
	'print')
		trash_count=$(ls -A "$trash_dir"/files/ -1 -U 2> /dev/null | wc -l)
		echo $trash_count
		;;
	'open')
		$TERMINAL --title=Floating --default-working-directory="$trash_dir/files/" -e ranger
		;;
	'clean')
		rm -rf "$trash_dir"/files/
		rm -rf "$trash_dir"/info/
		mpv ""$paren_dir"/trash-empty-sound.mp3"
		mkdir "$trash_dir"/files/
		mkdir "$trash_dir"/info/
		;;
	*)
		;;
esac