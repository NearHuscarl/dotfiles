#!/bin/env bash

# Usage:
# $ ./skeleton.sh

# Dependencies:

USAGE="Usage: skeleton.sh [help]"
HELP="\
skeleton.sh <command>
Commands:
  h, help      print this help message
  c, command   <command description>"

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

function die () {
	echo "$*" >&2
	exit 1
}

function usage() {
	die "$USAGE"
}

function help() {
	echo "$HELP"
}

function main() {
	local cmd="${1:-default_cmd}"

	case "$#" in
		0)
			usage ;;
		*)
			case "$volume_action" in
				h|help)
					help ;;
				*)
					usage ;;
			esac
	esac
}

main "$@"
