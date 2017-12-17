#!/bin/env bash

# Usage:
# $ ./volume.sh up
# $ ./volume.sh down
# $ ./volume.sh toggle

# Dependency:
# alsa
# dunst-git

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

function get_volume() {
	amixer get Master | grep '%' | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute() {
	amixer get Master | grep -F [off] 1> /dev/null
}

function get_icon() {
	local volume=$(get_volume)

	if is_mute; then
		echo ""$HOME"/.icons/dunst/volume-muted.svg"
	elif (( "$volume" < 33 )); then
		echo ""$HOME"/.icons/dunst/volume-low.svg"
	elif (( "$volume" < 66 )); then
		echo ""$HOME"/.icons/dunst/volume-medium.svg"
	elif (( "$volume" <= 100 )); then
		echo ""$HOME"/.icons/dunst/volume-high.svg"
	fi
}

function notify_volume() {
	local icon=$(get_icon)
	local volume=$(get_volume)
	local bar=$(seq -s "─" $(($volume / 3)) | sed 's/[0-9]//g')

	if is_mute; then
		dunstify \
			--urgency=low \
			--icon="$icon" \
			--replace=100 \
			' Muted'
	else
		dunstify \
			--urgency=low \
			--icon="$icon" \
			--replace=100 \
			"  $bar"
	fi
}

volume_action="${1:-toggle}"

case "$volume_action" in
	'toggle')
		amixer -q set Master toggle
		notify_volume
		;;
	'up')
		amixer -q set Master 2dB+ unmute
		notify_volume
		;;
	'down')
		amixer -q set Master 2dB- unmute
		notify_volume
		;;
	*)
		;;
esac
