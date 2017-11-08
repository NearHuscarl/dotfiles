#!/bin/bash

function check_update() {
	pac=$(checkupdates 2> /dev/null | wc -l )
	aur=$(cower -u 2> /dev/null | wc -l )

	check=$((pac + aur))
	if [[ "$check" != "0" ]]; then
		echo ""$pac" %{F$THEME_HL}%{F-} "$aur""
	elif [[ $? != 0 ]]; then
		echo "%{F$THEME_ALERT}%{F-} [pac_update]"
	else
		echo "0 %{F$THEME_HL}%{F-} 0"
	fi
}

if [[ "${1:-checkupdate}" == 'checkupdate' ]]; then
	check_update
elif [[ "$1" == 'update_pac' ]]; then
	# set title to Floating for i3 to regconize and make it a float window
	$TERMINAL --title="Floating" -e 'sudo pacman -Syu'
elif [[ "$1" == 'update_aur' ]]; then
	$TERMINAL --title="Floating" -e 'sudo pacaur -Syua'
fi
