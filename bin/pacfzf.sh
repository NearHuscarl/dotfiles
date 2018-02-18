#!/bin/env bash

# Usage:
# $ ./pacfzf

# Dependencies:
# pacman
# fzf

SCRIPT_NAME=$(basename "$0")
USAGE="Usage: $SCRIPT_NAME [help]"
HELP="\
$SCRIPT_NAME <command>
A wrapper script to integrate fzf with pacman
Commands:
  -h, --help          print this help message
  -I, --info          print package info
  -i, --install       install package
  -r, --remove        remove package
  -d, --dependencies  print package dependencies"

BACKUP_PATH="$HOME/.cache/packages"

set -o errexit
set -o pipefail
set -o nounset
set -E
trap '[ "$?" -ne 55 ] || exit 55' ERR

function die() { # {{{
	echo "$*" >&2
	exit 1
}
# }}}
function usage() { # {{{
	die "$USAGE"
}
# }}}
function help() { # {{{
	echo "$HELP"
}
# }}}
function get_pacman_packages() { # {{{
	local flag="$1"
	local select
	select="$(pacman -"$flag" | fzf --prompt='package: ' --height=30)"
	[[ "$select" == '' ]] && exit 55 || echo "$select"
}
# }}}
function get_local_packages() { # {{{
	get_pacman_packages Qq # official + aur
}
# }}}
function get_remote_packages() { # {{{
	get_pacman_packages Slq # official
}
# }}}
function get_local_aur_packages() { # {{{
	get_pacman_packages Qmq # aur
}
# }}}
function get_remote_aur_packages() { # {{{
	get_pacman_packages Slq
}
# }}}
function info() { # {{{
	local package
	package="$(get_remote_packages)"
	pacman -Si "$package"
}
# }}}
function install() { # {{{
	echo install
	pacman -Qqe | grep -v "$(pacman -Qqm)" > "$BACKUP_PATH"/pacman
}
# }}}
function remove() { # {{{
	local package
	package="$(get_local_packages)"
	sudo pacman -Rs "$package"
}
# }}}
function update() { # {{{
	sudo pacman -Syu
	notify-send --icon="$HOME/.icons/dunst/archlinux.png" 'pacman' 'Package updated'
   pacmerge
	paccache --remove --keep 3
}
# }}}
function dependencies() { # {{{
	echo dependencies
}
# }}}
function main() { # {{{
	local cmd="${1:-}"

	case "$#" in
		0)
			usage ;;
		*)
			case "$cmd" in
				-h|--help)
					help ;;
				-I|--info)
					info ;;
				-i|--install)
					install ;;
				-r|--remove)
					remove ;;
				-d|--dependencies)
					dependencies ;;
				*)
					usage ;;
			esac
	esac
}

main "$@"
# }}}
