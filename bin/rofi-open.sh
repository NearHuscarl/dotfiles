#!/bin/bash

rifle "$(rg $HOME --files --no-ignore --hidden --follow --no-messages \
   --glob "!{undo,.local}/*" \
   | rofi -threads 0 -width 80 -dmenu -i -p "ripgrep:")"
