#!/bin/env bash

# Dependencies:
# alsa

trash_dir="$HOME/.local/share/Trash"
parent_dir="$(dirname "$(readlink -f "$0")")"
icon_path="$HOME/.icons/dunst"
display_path="$(dirname "$0")"/display


function set_display_state() { # {{{
	echo "$1" > "$display_path"
}
# }}}
function get_display_state() { # {{{
	head -n 1 "$display_path"
}
# }}}
function print_trash_count() { # {{{
	# shellcheck disable=SC2012
	ls -A "$trash_dir"/files/ -1 -U 2> /dev/null | wc -l
	set_display_state 'count'
}
# }}}
function get_size() { # {{{
	du --total --human-readable --apparent-size "$1"
}
# }}}
function print_trash_size() { # {{{
	get_size "$trash_dir"/files/ | tail -n 1 | awk '{print $1}'
	set_display_state 'size'
}
# }}}
function print_trash_info() { # {{{
	# print trash info based on current display state (count or size)
	display_state="$(get_display_state)"

	if [[ "$display_state" == 'count' ]]; then
		print_trash_count
	elif [[ "$display_state" == 'size' ]]; then
		print_trash_size
	fi
}
# }}}
function toggle_format() { # {{{
	display_state="$(get_display_state)"

	if [[ "$display_state" == 'size' ]]; then
		print_trash_count
	elif [[ "$display_state" == 'count' ]]; then
		print_trash_size
	fi
}
# }}}
function clean_trash() { # {{{
	rm -rf "$trash_dir"/{files,info}/*
	print_trash_info
	dunstify --urgency=low --icon="$icon_path/trash.png" 'Trash has been deleted'
	aplay "$parent_dir/trash-empty-sound.wav" &> /dev/null &
}
# }}}

case ${1:-count} in
	print)
		print_trash_info ;;
	toggle)
		toggle_format ;;
	count)
		print_trash_count ;;
	size)
		print_trash_size ;;
	clean)
		clean_trash ;;
	*)
		;;
esac
