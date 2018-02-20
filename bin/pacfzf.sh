#!/bin/env bash

# Usage:
# $ ./pacfzf

# Dependencies:
# pacman
# trizen
# fzf


# BLACK="$(tput setaf 0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
# YELLOW="$(tput setaf 3)"
# BLUE="$(tput setaf 4)"
# MAGENTA="$(tput setaf 5)"
# CYAN="$(tput setaf 6)"
# WHITE="$(tput setaf 7)"
RESET="$(tput sgr0)"

SCRIPT_NAME=$(basename "$0")
USAGE="Usage: $SCRIPT_NAME [help]"
HELP="\
Description:
	A wrapper script to integrate fzf with pacman
Usage:
	$SCRIPT_NAME <command>
Commands:
  -h, --help          print this help message
  -I, --info          print package info
  -i, --install       install package
  -r, --remove        remove package
  -d, --dependencies  print package dependencies"

AUR_PKG_URL=https://aur.archlinux.org/packages.gz
CACHE_PATH="$HOME/.cache/pacfzf"
BACKUP_OFFICIAL="$CACHE_PATH"/Official_E
BACKUP_OFFICIAL_DEPS="$CACHE_PATH"/Official_D
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
	fzf --prompt='package: ' --height=30
}
# }}}
function get_all_local_packages() { # {{{
	pacman -Qq
}
# }}}
function get_all_remote_packages() { # {{{
	cat "$OFFICIAL_PKGS" "$AUR_PKGS"
}
# }}}
function get_official_local_packages() { # {{{
	pacman -Qnq
}
# }}}
function get_official_remote_packages() { # {{{
	cat "$OFFICIAL_PKGS"
}
# }}}
function get_aur_local_packages() { # {{{
	pacman -Qmq
}
# }}}
function get_aur_remote_packages() { # {{{
	cat "$AUR_PKGS"
}
# }}}
function get_packages() { # {{{
	local repo="$1"
	if "$repo" == 'official'; then
		get_official_remote_packages
	elif "$repo" == 'aur'; then
		get_aur_remote_packages
	elif "$repo" == 'all'; then
		get_all_remote_packages
	fi
}
# }}}
function info() { # {{{
	local package
	package="$(get_all_remote_packages | search)"
	[[ "$package" == '' ]] \
		&& trizen -Si "$package" 2> /dev/null \
		|| pacman -Si "$package" 2> /dev/null
}
# }}}
function backup_official() { # {{{
	pacman -Qneq > "$BACKUP_OFFICIAL"
}
# }}}
function backup_aur() { # {{{
	pacman -Qmeq > "$BACKUP_AUR"
}
# }}}
function backup_offical_deps() { # {{{
	comm -13 <(pacman -Qqdt | sort) <(pacman -Qqdtt | sort) > "$BACKUP_OFFICIAL_DEPS"
}
# }}}
function install_official_backup() { # {{{
	xargs pacman -S --needed --noconfirm < "$BACKUP_OFFICIAL"
	xargs pacman -S --needed --noconfirm --asdeps < "$BACKUP_OFFICIAL_DEPS"
}
# }}}
function install() { # {{{
	echo install
	backup_official # backup explicit offical packages
}
# }}}
function remove() { # {{{
	local package
	package="$(get_all_local_packages)"
	[[ "$package" == '' ]] && exit 55 || sudo pacman -Rs "$package"
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
	# help info install remove dependencies
	local OPTIND opt cmd repo

	# shellcheck disable=SC2059
	function handle_operation_opt() { # {{{
		if [[ "${cmd:-}" == '' ]]; then
			cmd="$1"
		else
			printf "${RED}"'Error:'"${RESET}"' Only one operation is allowed\n'
			exit 1
		fi
	}
	# }}}
	# shellcheck disable=SC2059
	function handle_repo_opt() { # {{{
		if [[ "${repo:-}" == '' ]]; then
			repo="$1"
		else
			if [[ "$repo" == "$1" ]] || [[ "$repo" == all ]]; then
				printf "${RED}"'Error:'"${RESET}"' Specify to search only in official or AUR repo\n'
				exit 1
			else
				repo=all
			fi
		fi
	}
	# }}}

	while getopts ':hiIrao-:' opt; do
		case "${opt}" in
			-)
				case ${OPTARG} in # a hack to use --option
					help)
						handle_operation_opt help
						;;
					info)
						handle_operation_opt info
						;;
					install)
						handle_operation_opt install
						;;
					remove)
						handle_operation_opt remove
						;;
					aur)
						handle_repo_opt aur
						;;
					official)
						handle_repo_opt official
						;;
					*)
						printf "${RED}Error:${RESET} Invalid argument ${GREEN}--%s"'\n'"${RESET}" "$OPTARG"
						exit 1
						;;
				esac
				;;
			h)
				handle_operation_opt help
				;;
			I)
				handle_operation_opt info
				;;
			i)
				handle_operation_opt install
				;;
			r)
				handle_operation_opt remove
				;;
			a)
				handle_repo_opt aur
				;;
			o)
				handle_repo_opt official
				;;
			*)
				printf "${RED}Error:${RESET} Invalid argument ${GREEN}-%s"'\n'"${RESET}" "$OPTARG"
				exit 1
				;;
		esac
	done
	: "${repo:=official}"
	[[ ! "${cmd:-}" ]] && printf "${RED}"'Error: '"${RESET}"'Missing operation\n'"${RESET}" && exit 1
	printf 'cmd: %s\n' "$cmd"
	printf 'repo: %s\n' "$repo"
	shift $((OPTIND-1))

	eval "$cmd"
}

main "$@"
# }}}

# TODO:
# backup when?
# update cache when?
