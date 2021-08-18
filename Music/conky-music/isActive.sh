#!/bin/bash
cd "$(dirname "$(realpath "$0")")"

if [[ -n $(./spotify/scripts/isActive.sh) ]]; then
	echo "spotify"
elif [[ -n $(./clementine/scripts/isActive.sh) ]]; then
	echo "clementine"
fi
