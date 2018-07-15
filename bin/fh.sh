#!/bin/env bash

# Usage:
# $ ./fh

# Dependencies:
# bash
# fzf

SCRIPT_NAME=$(basename "$0")
USAGE="Usage: $SCRIPT_NAME [help]"
HELP="\
$SCRIPT_NAME [<command>]
Commands:
  h, help      print this help message"

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

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
function fzf_history() { # {{{
	local hist
	hist="$(history)"
	echo "$hist"
	# hist="$([[ "${ZSH_NAME:-}" != '' ]] && fc -l 1 || history)"
	# echo "$hist" | fzf --tac --no-sort | sed 's/ *[0-9]* *//'
}
# }}}
function main() { # {{{
	local cmd="${1:-}"

	case "$#" in
		0)
			fzf_history
			;;
		*)
			case "$cmd" in
				-h|--help)
					help
					;;
				*)
					usage
					;;
			esac
	esac
}

main "$@"
# }}}
