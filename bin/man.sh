#!/bin/bash

# a simple menu to select and open manpages from rofi
# (c) 2015, avx
# License: WTFPL


MAN_STORE="${HOME}/.config/rofi/man/"
MAN_DB="${MAN_STORE}/man.db"
MAN_PATH="/usr/share/man/"
MAN_EXT="xz"
TERMINAL="termite"

function create_db() {
  find "${MAN_PATH}" -iname "*.${MAN_EXT}" -printf "%f\n" | \
    sed -e "s/\.${MAN_EXT}//g" | \
    sort -u > "${MAN_DB}"
}

[[ ! -d "${MAN_STORE}" ]] && mkdir -p "${MAN_STORE}" > /dev/null
[[ ! -e "${MAN_DB}" ]] && create_db

[[ ! -z "$1" ]] && [[ "$1" == "-u" ]] && create_db

RESULT=$( rofi -dmenu -p "manpage: " < "${MAN_DB}" )

for res in $(echo $RESULT | sed -e "s/\n/ /g")
do
  "${TERMINAL}" -e man "${res:e}" "${res:r}"
done
