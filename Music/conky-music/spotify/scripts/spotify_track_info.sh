#!/bin/bash
cd "$(dirname "$(realpath "$0")")"

#GET AUTHORIZATION: https://developer.spotify.com/my-applications/
#to get the token, generate a base64 with client_id:cliente_secret
#Possible to use a site like: https://www.base64encode.org/
#Create a file token in this folder and paste the token

bearerToken=`cat token | xargs`

json_return=`curl -H "Authorization: Basic $bearerToken" -d grant_type=client_credentials https://accounts.spotify.com/api/token`
spotifyToken=`jq -r '.access_token' <<< $json_return`

spotifyTrack=`curl -X GET https://api.spotify.com/v1/tracks/$1 -H "Authorization: Bearer $spotifyToken"`
#echo $spotifyTrack
echo $spotifyTrack > /tmp/conky-spotify/spotify-track.txt

artist_id=$(echo $spotifyTrack | jq -r '.artists[0].id')
spotifyArtist=`curl -X GET https://api.spotify.com/v1/artists/$artist_id -H "Authorization: Bearer $spotifyToken"`
echo $spotifyArtist > /tmp/conky-spotify/spotify-artist.txt

