#!/bin/env bash

# trigger the hook to update trash info after an interval
function update() {
	local filecount
	echo 'running trash hook watcher..'
	while sleep 3; do
		filecount="$(find /tmp/polybar_mqueue.* 2> /dev/null | wc -l)"
		if ((filecount != 1)); then
			notify-send 'polybar hook module/trash3 failed to send!'
			exit 1
		fi
		echo hook:module/trash3 >> "$(find /tmp/polybar_mqueue.*)"
	done
}

update
