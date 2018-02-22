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
YELLOW="$(tput setaf 3)"
# BLUE="$(tput setaf 4)"
# MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
# WHITE="$(tput setaf 7)"
RESET="$(tput sgr0)"

SCRIPT_NAME=$(basename "$0")
USAGE="Usage: $SCRIPT_NAME [help]"
HELP="\
${YELLOW}Description:${RESET}
  A wrapper script to integrate fzf with pacman
${YELLOW}Usage:${RESET}
  $SCRIPT_NAME <command>
${YELLOW}Commands:
  ${CYAN}-h  --help          ${RESET}print this help message
  ${CYAN}-I  --info          ${RESET}print package info
  ${CYAN}-i  --install       ${RESET}install package
  ${CYAN}-r  --remove        ${RESET}remove package
  ${CYAN}-d  --dependencies  ${RESET}print package dependencies
${YELLOW}Repo:
  ${CYAN}-o  --official      ${RESET}official packages
  ${CYAN}-a  --aur           ${RESET}AUR packages"

: ${AUR_PKG_URL:=https://aur.archlinux.org/packages.gz}
: ${CACHE_PATH:="$HOME/.cache/pacfzf"}

: ${BACKUP_OFFICIAL:="$CACHE_PATH"/Official_E}  # (E)xplicit installed packages
: ${BACKUP_OFFICIAL_DEPS:="$CACHE_PATH"/Official_D}
: ${BACKUP_AUR:="$CACHE_PATH"/AUR_E}

: ${OFFICIAL_PKGS:="$CACHE_PATH/Official"}
: ${AUR_PKGS:="$CACHE_PATH/AUR"}

: ${AUR_HELPER:=trizen}

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
function search() { # {{{
	fzf --prompt='package: ' --height=30
}
# }}}
function get_all_local_packages() { # {{{
	pacman -Qq
}
# }}}
function get_all_remote_pks() { # {{{
	cat "$OFFICIAL_PKGS" "$AUR_PKGS"
}
# }}}
function get_official_local_pkgs() { # {{{
	pacman -Qnq
}
# }}}
function get_official_remote_pkgs() { # {{{
	cat "$OFFICIAL_PKGS"
}
# }}}
function get_aur_local_pkgs() { # {{{
	pacman -Qmq
}
# }}}
function get_aur_remote_pkgs() { # {{{
	cat "$AUR_PKGS"
}
# }}}
function get_packages() { # {{{
	local repo="$1"
	local local_or_remote="$2"

	if [[ "$repo" == 'official' ]]; then
		if [[ "$local_or_remote" == local ]]; then
			get_official_local_pkgs
		elif [[ "$local_or_remote" == remote ]]; then
			get_official_remote_pkgs
		fi
	elif [[ "$repo" == 'aur' ]]; then
		if [[ "$local_or_remote" == local ]]; then
			get_aur_local_pkgs
		elif [[ "$local_or_remote" == remote ]]; then
			get_aur_remote_pkgs
		fi
	elif [[ "$repo" == 'all' ]]; then
		if [[ "$local_or_remote" == local ]]; then
			get_all_local_pkgs
		elif [[ "$local_or_remote" == remote ]]; then
			get_all_remote_pkgs
		fi
	fi
}
# }}}
function cache_official_local_pkgs() { # {{{
	pacman -Qneq > "$BACKUP_OFFICIAL"
}
# }}}
function cache_official_remote_pkgs() { # {{{
	pacman -Slq > "$OFFICIAL_PKGS" # save to cache to retrieve info faster
}
# }}}
function cache_aur_local_pkgs() { # {{{
	pacman -Qmeq > "$BACKUP_AUR"
}
# }}}
function cache_aur_remote_pkgs() { # {{{
	curl --fail --silent "$AUR_PKG_URL" | gunzip --stdout | sed 1d > "$AUR_PKGS"
}
# }}}
function cache_official_deps() { # {{{
	comm -13 <(pacman -Qqdt | sort) <(pacman -Qqdtt | sort) > "$BACKUP_OFFICIAL_DEPS"
}
# }}}
function update_cache() { # {{{
	local repo="$1" database="$2"
	printf 'Caching package list...\n'
	if [[ "$repo" =~ (o|official) ]]; then
		if [[ "$database" =~ (r|remote) ]]; then
			cache_official_remote_pkgs
		elif [[ "$database" =~ (l|local) ]]; then
			cache_official_local_pkgs # backup explicit official packages
			cache_official_deps
		fi
	elif [[ "$repo" =~ (a|aur) ]]; then
		if [[ "$database" =~ (r|remote) ]]; then
			cache_aur_remote_pkgs
		elif [[ "$database" =~ (l|local) ]]; then
			cache_aur_local_pkgs
		fi
	fi
}
# }}}
function install_official_backup() { # {{{
	xargs pacman -S --needed --noconfirm < "$BACKUP_OFFICIAL"
	xargs pacman -S --needed --noconfirm --asdeps < "$BACKUP_OFFICIAL_DEPS"
}
# }}}
function info() { # {{{
	local package repo="$1" database="$2"
	package="$(get_packages "$repo" "$database" | search)"
	[[ "$package" == '' ]] && exit 55
	if ! pacman -Si "$package"; then
		 eval "$AUR_HELPER" -Si "$package"
	fi
}
# }}}
function install() { # {{{
	local package repo="$1"
	package="$(get_packages "$repo" 'remote' | search)"
	[[ "$package" == '' ]] && exit 55
	if [[ "$repo" =~ (o|official) ]]; then
		sudo pacman -Syu "$package"
	elif [[ "$repo" =~ (a|aur) ]]; then
		eval "$AUR_HELPER -Syu" "$package"
	fi
	update_cache "$repo" remote
}
# }}}
function remove() { # {{{
	local package repo="$1"
	package="$(get_packages "$repo" 'local' | search)"
	if [[ "$package" == '' ]]; then
		exit 55
	else
		sudo pacman -Rs "$package"
	fi
	update_cache "$repo" local
}
# }}}
function update() { # {{{
	local package repo="$1"
	sudo pacman -Syu
	notify-send --icon="$HOME/.icons/dunst/archlinux.png" 'pacman' 'Package updated'
   pacmerge
	paccache --remove --keep 3
	update_cache "$repo" local
}
# }}}
function dependencies() { # {{{
	echo dependencies
}
# }}}
function execute() { # {{{
	local cmd="$1" repo="$2" database="$3"

	package="$(get_packages "$repo" "$database" | search)"
	if [[ "$repo" == official ]]; then
		echo pacman "$cmd" "${package:-}"
	elif [[ "$repo" == aur ]]; then
		echo "$AUR_HELPER" "$cmd" "${package:-}"
	fi
	# eval "$cmd $repo $database"
}
# }}}
# shellcheck disable=SC2059
function main() { # {{{
	# help info install remove dependencies
	local OPTIND opt cmd repo database flag

	function handle_operation_opt() { # {{{
		if [[ "${cmd:-}" == '' ]]; then
			cmd="$1"
		else
			die "${RED}"'Error:'"${RESET}"' Only one operation is allowed'
		fi

		if [[ "$cmd" =~ (Q|R|query|remove) ]]; then
			database=local
		elif [[ "$cmd" =~ (S|U|sync|update) ]]; then
			database=remote
		fi
	}
	# }}}
	function handle_repo_opt() { # {{{
		if [[ "${repo:-}" == '' ]]; then
			repo=aur
		else
			die "${RED}"'Error:'"${RESET}"' Replicated options'
		fi
	}
	# }}}

	while getopts ':hVQRSUa-:' opt; do
		case "${opt}" in
			-)
				case ${OPTARG} in # a hack to use --option
					help)
						handle_operation_opt --"$OPTARG"
						;;
					version)
						handle_operation_opt --"$OPTARG"
						;;
					query)
						handle_operation_opt --"$OPTARG"
						;;
					remove)
						handle_operation_opt --"$OPTARG"
						;;
					sync)
						handle_operation_opt --"$OPTARG"
						;;
					aur)
						handle_repo_opt "$OPTARG"
						;;
					*)
						flag+=" --${OPTARG}"
						;;
				esac
				;;
			h)
				handle_operation_opt help
				;;
			V)
				handle_operation_opt -"$opt"
				;;
			Q)
				handle_operation_opt -"$opt"
				;;
			R)
				handle_operation_opt -"$opt"
				;;
			S)
				handle_operation_opt -"$opt"
				;;
			U)
				handle_operation_opt -"$opt"
				;;
			a)
				handle_repo_opt "$opt"
				;;
			*)
				flag+=" -${OPTARG}"
				;;
		esac
	done
	: "${repo:=official}"
	: "${database:=remote}"
	: "${flag:=}"
	[[ ! "${cmd:-}" ]] && die "${RED}"'Error: '"${RESET}"'Missing operation'"${RESET}"

	printf 'cmd: %s\n' "$cmd"
	printf 'repo: %s\n' "$repo"
	printf 'database: %s\n' "$database"
	printf 'flag: %s\n' "$flag"
	shift $((OPTIND-1))

	cmd+="$flag"
	execute "$cmd" "$repo" "$database"
}

main "$@"
# }}}

# TODO:
# backup when?
# update cache when?
# update default to all packages
