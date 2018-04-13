#!/bin/env bash

# general function to update polybar hooks

function update_cache() {
	local filecount
	echo "running $HOOK_NAME hook watcher.."
	while sleep "$UPDATE_INTERVAL"; do
		filecount="$(find /tmp/polybar_mqueue.* 2> /dev/null | wc -l)"
		if ((filecount > 1)); then
			notify-send "polybar hook $HOOK_NAME failed to send!"
			exit 1
		fi
		echo "$HOOK_CMD" >> "$(find /tmp/polybar_mqueue.*)"
	done
}

update_cache
