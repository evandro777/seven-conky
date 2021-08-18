#!/bin/bash
FILEURL=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | egrep -A 1 ":url" | egrep -v ":url" | cut -b 44- | cut -d '"' -f 1 | egrep -v ^$`
#echo ${FILEURL:7}
echo $FILEURL

