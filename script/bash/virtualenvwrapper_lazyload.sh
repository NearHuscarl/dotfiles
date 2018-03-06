#!/bin/bash
# ============================================================================
# File:        virtualenvwrapper_lazyload.sh
# Description: Lazyload virtualenvwrapper.sh because it's too slow when source
#              it in ~/.bashrc
# Author:      Near Huscarl <near.huscarl@gmail.com>
# Last Change: Tue Mar 06 11:27:54 +07 2018
# Licence:     BSD 3-Clause license
# Note:        N/A
# ============================================================================

# shellcheck disable=SC1094

workon() {
	unset -f "${FUNCNAME[0]}"
	source /usr/bin/virtualenvwrapper.sh

	if [[ $(type -t "${FUNCNAME[0]}") != function ]]; then
		echo 'virtualenvwrapper.sh not found'
	else
		${FUNCNAME[0]}
	fi
}

mkvirtualenv() {
	unset -f "${FUNCNAME[0]}"
	source /usr/bin/virtualenvwrapper.sh

	if [[ $(type -t "${FUNCNAME[0]}") != function ]]; then
		echo 'virtualenvwrapper.sh not found'
	else
		${FUNCNAME[0]} "$@"
	fi
}
