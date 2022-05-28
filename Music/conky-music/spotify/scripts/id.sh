#!/bin/bash

dbus-send \
    --print-reply=literal \
    --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' \
    | grep mpris:trackid \
    | awk '{ print $(NF-1) }' \
    | rev \
    | cut -d "/" -f1 \
    | rev

# Alternative:
#dbus-send \
#    --print-reply \
#    --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' \
#    | egrep -A 1 "trackid" \
#    | egrep -v "trackid" \
#    | cut -b 44- \
#    | cut -d '"' -f 1 \
#    | rev \
#    | cut -d "/" -f1 \
#    | rev

