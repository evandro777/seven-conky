#!/bin/bash

if [[ -n $(pidof clementine) ]] && [[ -n $(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata') ]]; then
	echo 1;
fi
