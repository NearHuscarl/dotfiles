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

AUR_PKG_URL=https://aur.archlinux.org/packages.gz
CACHE_PATH="$HOME/.cache/pacfzf"
BACKUP_OFFICIAL="$CACHE_PATH"/Official_E
BACKUP_AUR="$CACHE_PATH"/AUR_E
OFFICIAL_PKGS="$CACHE_PATH/Official"
AUR_PKGS="$CACHE_PATH/AUR"

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
function update_aur_list() { # {{{
	curl --fail --silent "$AUR_PKG_URL" | gunzip --stdout | sed 1d > "$AUR_PKGS"
}
# }}}
function update_official_list() { # {{{
	pacman -Slq > "$OFFICIAL_PKGS" # save to cache to retrieve info faster
}
# }}}
function update_cache() { # {{{
	update_official_list
	update_aur_list
}
# }}}
function search() { # {{{
	local packages="$1"
	local select
	select="$(echo "$packages" | fzf --prompt='package: ' --height=30)"
	[[ "$select" == '' ]] && exit 55 || echo "$select"
}
# }}}
function get_all_local_packages() { # {{{
	local pkg
	pkg="$(pacman -Qq)"
	search "$pkg"
}
# }}}
function get_all_remote_packages() { # {{{
	local pkg
	pkg="$(cat "$OFFICIAL_PKGS" "$AUR_PKGS")"
	search "$pkg"
}
# }}}
function get_official_local_packages() { # {{{
	local pkg
	pkg="$(pacman -Qq | grep -v -Qmq)"
	search "$pkg"
}
# }}}
function get_official_remote_packages() { # {{{
	local pkg
	pkg="$(cat "$OFFICIAL_PKGS")"
	search "$pkg"
}
# }}}
function get_aur_local_packages() { # {{{
	local pkg
	pkg="$(pacman -Qmq)"
	search "$pkg"
}
# }}}
function get_aur_remote_packages() { # {{{
	local pkg
	pkg="$(cat "$AUR_PKGS")"
	search "$pkg"
}
# }}}
function info() { # {{{
	local package
	package="$(get_all_remote_packages)"
	pacman -Si "$package"
}
# }}}
function backup_official() { # {{{
	pacman -Qeq | grep -v "$(pacman -Qmq)" > "$BACKUP_OFFICIAL"
}
# }}}
function backup_aur() { # {{{
	pacman -Qmeq > "$BACKUP_AUR"
}
# }}}
function install_official_backup() { # {{{
	xargs pacman -S --needed --noconfirm < "$BACKUP_OFFICIAL"
}
# }}}
function install() { # {{{
	echo install
	backup_official # backup explicit offical packages
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
	update_cache
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

# TODO:
# backup when?
# update cache when?
