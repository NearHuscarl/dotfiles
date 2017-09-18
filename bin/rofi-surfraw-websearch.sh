#!/bin/bash

if [[ -z $BROWSER ]]; then
   BROWSER='google-chrome-stable'
fi

surfraw -browser=$BROWSER \
   $( \
     sr -elvi | \
     awk -F'-' '{print $1}' | \
     sed '/:/d' | \
     awk '{$1=$1};1' | \
     rofi -kb-row-select "Tab" \
          -kb-row-tab "Control+space" \
          -dmenu -mesg ">> Tab = Autocomplete" \
          -i -p "websearch: " \
    )

