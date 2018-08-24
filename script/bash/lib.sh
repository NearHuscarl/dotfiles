#!/bin/env bash

# a list of utility functions

function gitroot() { # {{{
	git rev-parse --show-toplevel 2> /dev/null
}
# }}}
function has_command() { # {{{
	# check command avalability
	# usage:
	# $ if has_command vim; then
	# $    vim /tmp/temp
	# $ fi
	command -v $1 > /dev/null
}
# }}}
function notify() { # {{{
	local title="$1" message="$2" icon="$3"
	if [[ -x /usr/share/dunstify ]]; then
		dunstify --replace=101 --urgency=low --icon="$icon" "$message"
	else
		notify-send --urgency=low --icon="$icon" "$title" "$message"
	fi
}
# }}}
get_script_dir() { # {{{
	SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
}
# }}}
read_file_content() { # {{{
	while read -r line ; do
		CONTENT+="$line "
	done < "/path/to/file"
}
# }}}
