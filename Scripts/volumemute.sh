#!/usr/bin/env bash

pactl set-sink-mute 0 toggle

if [ $(echo `(pactl list sinks | grep "Mute: ")| awk '{print $2}'`) = "yes" ]
then
	volnoti-show -m
else
	volnoti-show $(echo `(pactl list sinks | grep "Volume: front-left")| awk '{print $5}'` | tr -d %)
fi

# pulseaudio-ctl mute

# if [ $(pulseaudio-ctl full-status | tr -d yes | wc -c) -lt $(pulseaudio-ctl full-status | wc -c) ]
# then
#	volnoti-show -m
# else
#	volnoti-show $(echo `pulseaudio-ctl current` | tr -d %)
# fi
