#!/bin/bash
cd "$(dirname "$(realpath "$0")")"
genres=`echo $(cat /tmp/conky-spotify/spotify-artist.txt) | jq -rc '.genres'`
genres=`echo $genres | sed -e "s/\",\"/\, /g"` # SUBSTITUI "," POR , 
genres=`echo $genres | sed -e "s/\[\"/\ /g"` # SUBSTITUI [" POR
genres=`echo $genres | sed -e "s/\"\]/\ /g"` # SUBSTITUI "] POR
genres=`echo $genres | sed -e "s/null/\ /g"` # SUBSTITUI null POR
echo $genres
