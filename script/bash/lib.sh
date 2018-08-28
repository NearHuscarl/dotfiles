#!/bin/env bash

# global variables and utility functions

# COLORS {{{
BOLD=$(tput bold)
UNDERLINE=$(tput sgr 0 1)
RESET=$(tput sgr0)

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
PURPLE=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

BRED=${Bold}${Red}
BGREEN=${Bold}${Green}
BYELLOW=${Bold}${Yellow}
BBLUE=${Bold}${Blue}
BPURPLE=${Bold}${Purple}
BCYAN=${Bold}${Cyan}
BWHITE=${Bold}${White}
# }}}

enter_to_continue() { # {{{
	# breakpoint
	read -e -sn 1 -p 'Press enter to continue...'
}
# }}}

gitroot() { # {{{
	git rev-parse --show-toplevel 2> /dev/null
}
# }}}
notify() { # {{{
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

has_command() { # {{{
	# check command avalability
	# usage:
	# $ if has_command vim; then
	# $    vim /tmp/temp
	# $ fi
	command -v "$1" > /dev/null
}
# }}}
has_package() { # {{{
	# check if a package is already installed (pacman)
	# $ if ! has_package nvim; then
	# $    pacman -S nvim
	# $ fi
	pacman -Q "$1" &> /dev/null && return 0;
	return 1
}
# }}}
