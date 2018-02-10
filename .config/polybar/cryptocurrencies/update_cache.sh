#!/bin/env bash

# trigger the hook to update crypto info after an interval
function update_cache() {
	local filecount
	echo 'running crypto hook watcher..'
	while sleep 200; do
		filecount="$(find /tmp/polybar_mqueue.* 2> /dev/null | wc -l)"
		if ((filecount != 1)); then
			notify-send 'polybar hook module/crypto3 failed to send!'
			exit 1
		fi
		echo hook:module/crypto3 >> "$(find /tmp/polybar_mqueue.*)"
	done
}

update_cache
