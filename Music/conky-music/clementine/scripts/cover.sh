#!/bin/bash
cd "$(dirname "$(realpath "$0")")"
tmp_path="/tmp/conky-clementine/"
id_current_path="${tmp_path}current_song_id.txt"
cover_current_path="${tmp_path}current_cover.jpg"
cover_empty_path="../covers/empty.jpg"

mkdir -p "$tmp_path"
touch "$id_current_path"
id_current=$(cat "$id_current_path")
id_new=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | egrep -A 1 ":artUrl" | egrep -v ":artUrl" | cut -b 44- | cut -d '"' -f 1 | egrep -v ^$`

if [ "$id_new" != "$id_current" ]; then
	if [ "$id_new" != "" ]; then
		imgPath=${id_new:7}
		cp "${imgPath}" "$cover_current_path" #COPY NEW IMAGE TO CURRENT
	else
		cp "$cover_empty_path" "$cover_current_path" #COPY DEFAULT IMAGE
	fi
	echo $id_new > "$id_current_path" #UPDATE NEW ID
elif [[ ! -f "$cover_current_path" ]]; then #CHECK IF COVER IMAGE DOESN'T EXIST (FALLBACK FOR EMPTY COVER)
	cp "$cover_empty_path" "$cover_current_path" #COPY DEFAULT IMAGE
fi

echo "$cover_current_path"

