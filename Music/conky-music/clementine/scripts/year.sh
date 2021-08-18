#!/bin/bash
dbus-send --print-reply --dest=org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | egrep -A 1 "year" | egrep -v "year" | cut -b 42- | cut -d '"' -f 1 | egrep -v ^$

