sudo updatedb
xdg-open "$(locate home media | rofi -threads 0 -width 80 -dmenu -i -p "locate:")"
