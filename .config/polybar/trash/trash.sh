#!/bin/env bash

# Dependencies:
# alsa

TRASH_PATH="$HOME/.local/share/Trash"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ICON_PATH="$HOME/.icons/dunst"
CACHE_PATH="$HOME/.cache/polybar/trash"
DEFAULT_DISPLAY='size' # size or count


function set_display_state() { # {{{
	if [[ ! -d "$CACHE_PATH" ]]; then
		mkdir -pv "$CACHE_PATH"
	fi
	echo "$1" > "$CACHE_PATH/display"
}
# }}}
function get_display_state() { # {{{
	if [[ ! -d "$CACHE_PATH" ]]; then
		mkdir -pv "$CACHE_PATH"
		echo "$DEFAULT_DISPLAY" > "$CACHE_PATH/display"
	fi
	head -n 1 "$CACHE_PATH/display"
}
# }}}
function get_size() { # {{{
	du --total --human-readable --apparent-size "$1"
}
# }}}

function print_trash_count() { # {{{
	# shellcheck disable=SC2012
	ls -A "$TRASH_PATH/files/" -1 -U 2> /dev/null | wc -l
	set_display_state 'count'
}
# }}}
function print_trash_size() { # {{{
	get_size "$TRASH_PATH"/files/ | tail -n 1 | awk '{print $1}'
	set_display_state 'size'
}
# }}}
function print_trash_info() { # {{{
	# print trash info based on current display state (count or size)
	display_state="$(get_display_state)"

	echo "$(print_trash_count)/$(print_trash_size)"
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
function open_trash() { # {{{
	xdg-open "$TRASH_PATH" &> /dev/null
}
# }}}
function clean_trash() { # {{{
	rm -rf "$TRASH_PATH"/{files,info}/*
	dunstify --urgency=low --icon="$ICON_PATH/trash.png" 'Trash has been deleted'
	aplay "$SCRIPT_DIR/trash-empty-sound.wav" &> /dev/null &
	print_trash_info
}
# }}}

case ${1:-count} in
	count)
		print_trash_count ;;
	size)
		print_trash_size ;;
	print)
		print_trash_info ;;
	toggle)
		toggle_format ;;
	open)
		open_trash ;;
	clean)
		clean_trash ;;
	*)
		;;
esac
