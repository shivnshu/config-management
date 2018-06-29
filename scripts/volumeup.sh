#!/usr/bin/env bash

sh -c "pactl set-sink-mute 0 false ; pactl set-sink-volume 0 +5%"
volnoti-show $(echo `(pactl list sinks | grep "Volume: front-left")| awk '{print $5}'` | tr -d %)

# pulseaudio-ctl up 5
# volnoti-show $(echo `pulseaudio-ctl current` | tr -d %)
