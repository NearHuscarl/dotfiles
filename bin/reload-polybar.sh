#!/bin/bash

if [[ -x /usr/bin/polybar ]]; then
   killall -q polybar
   polybar -r holybar
else
   printf "polybar is not installed. Nothing to reload\n"
fi
