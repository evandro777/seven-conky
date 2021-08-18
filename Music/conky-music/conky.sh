#!/bin/bash
cd "$(dirname "$(realpath "$0")")"
detectPlayer=$(./isActive.sh)

if [[ -n "$detectPlayer" ]]; then
	echo '${image '$(./"$detectPlayer"/scripts/cover.sh)' -p 0,0 -s 112x112}'
	echo '${image conky-music/'"${detectPlayer}"'/player-ico.png -p 0,0 -s 24x24}'
	#echo '${image conky-music/background.png -p 0,0 -s 490x170}${voffset -15}'
	# --- Show now playing information ---
	echo '${voffset -70}'
	echo '${goto 124}${font Noto Sans:size=8}Title:'
	echo '${goto 132}${font Ubuntu:size=11}'$(./"$detectPlayer"/scripts/title.sh)
	echo '${goto 124}${font Noto Sans:size=8}Artist:'
	echo '${goto 132}${font Ubuntu:size=11}'$(./"$detectPlayer"/scripts/artist.sh)
	echo '${goto 124}${font Noto Sans:size=8}Album:'
	echo '${goto 132}${font Ubuntu:size=11}'$(./"$detectPlayer"/scripts/album.sh)
	#${goto 124}${font Noto Sans:size=8}Genre:
	#${goto 132}${font Ubuntu:size=11}${exec conky-music/spotify/scripts/genre.sh}
fi
