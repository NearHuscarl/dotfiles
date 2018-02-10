#!/bin/env bash

# Dependencies:
# alsa

trash_dir="$HOME/.local/share/Trash/"
parent_dir="$(dirname "$(readlink -f "$0")")"


function print_trash_info() { # {{{
	# shellcheck disable=SC2012
	trash_count=$(ls -A "$trash_dir"/files/ -1 -U 2> /dev/null | wc -l)
	trash_size=$(du --total --human-readable --apparent-size "$trash_dir"/files/ \
		| tail -n 1 | awk '{print $1}')
	echo "$trash_count ($trash_size)"
}
# }}}
function open_trash_bin() { # {{{
	$TERMINAL --title=Floating --default-working-directory="$trash_dir/files/" -e ranger
}
# }}}
function clean_trash() { # {{{
	rm -rf "$trash_dir"/{files,info}/*
	aplay "$parent_dir/trash-empty-sound.wav"
}
# }}}

case ${1:-print} in
	'print')
		print_trash_info
		;;
	'open')
		open_trash_bin
		;;
	'clean')
		clean_trash
		;;
	*)
		;;
esac
