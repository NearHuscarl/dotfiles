#!/bin/bash
pac=$(checkupdates 2> /dev/null | wc -l )
aur=$(cower -u 2> /dev/null | wc -l )

check=$((pac + aur))
if [[ "$check" != "0" ]]
then
    echo "$pac %{F-} $aur"
fi
