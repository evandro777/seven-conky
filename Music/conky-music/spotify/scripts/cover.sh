#!/bin/bash
cd "$(dirname "$(realpath "$0")")"
tmp_path="/tmp/conky-spotify/"
covers_path="${tmp_path}covers/"
id_current_path="${tmp_path}current_song_id.txt"
cover_current_path="${tmp_path}current_cover.jpg"
cover_empty_path="../covers/empty.jpg"

mkdir -p "${covers_path}"
touch "$id_current_path"
id_current=$(cat "$id_current_path")
id_new=`./id.sh`

cover=
imgurl=

if [ "$id_new" != "$id_current" ]; then
	cover=`ls "$covers_path" | grep $id_new`

	if [ "$cover" == "" ]; then
		#DEFAULT IMAGE
		cp "$cover_empty_path" "$cover_current_path"
		
		# START PROCESS TO GET NEW IMAGE
		#./spotify_track_info.sh $id_new # Get a lot of info like title, artist, genres, country
		imgurl=`./imgurl.sh`
		wget -O "${covers_path}${id_new}.jpg" $imgurl
		cover=`ls "${covers_path}" | grep $id_new`
	fi

	if [ "$cover" != "" ]; then
		#MOVE NEW IMAGE TO CURRENT
		cp "${covers_path}$cover" "$cover_current_path"
	else
		#DEFAULT IMAGE
		cp "$cover_empty_path" "$cover_current_path"
	fi

	#UPDATE NEW ID
	echo $id_new > $id_current_path
fi

echo "$cover_current_path"
