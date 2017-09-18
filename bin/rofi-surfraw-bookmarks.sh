#!/bin/bash

if [[ -z $BROWSER ]]; then
   BROWSER='google-chrome-stable'
fi

surfraw -browser=$BROWSER \
   "$( \
     cat ~/.config/surfraw/bookmarks | \
     sed '/^$/d' | \
     sed '/^#/d' | \
     sed '/^\//d' | \
     sort -n | \
     rofi -dmenu \
          -mesg ">> Edit to add new bookmarks at ~/.config/surfraw/bookmarks" \
          -i -p "rofi-surfraw-bookmarks: " \
     )"
