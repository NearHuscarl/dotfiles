#!/bin/bash

function get_fifos() { # {{{
	find /tmp/polybar_mqueue.* -type p -printf '%f\n' 2> /dev/null
}
# }}}
function present() { # {{{
	local pids fifo="$1"
	pids="$(pidof polybar)"
	for pid in $pids; do
		if [[ "$fifo" =~ .*\.$pid ]]; then
			echo true
			return
		fi
	done
	echo false
}
# }}}
function clear_fifo() { # {{{
	# sometimes when reload or close polybar
	# /tmp/polybar_mqueue.* are not removed for some reasons
	local fifos
	fifos="$(get_fifos)"
	for fifo in $fifos; do
		if [[ "$(present "$fifo")" == false ]]; then
			rm "/tmp/$fifo"
		fi
	done
}
# }}}

clear_fifo
