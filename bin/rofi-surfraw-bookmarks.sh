#!/bin/bash

browser='vivaldi-stable'

surfraw -browser=$browser \
   "$( \
     cat ~/.config/surfraw/bookmarks | \
     sed '/^$/d' | \
     sed '/^#/d' | \
     sed '/^\//d' | \
     sort -n | \
     rofi -dmenu \
          -mesg "add more bookmark at: ~/.config/surfraw/bookmarks" \
          -i -p "bookmarks: " \
     )"
