#!/bin/bash

pulseaudio-ctl mute

if [ $(pulseaudio-ctl full-status | tr -d yes | wc -c) -lt $(pulseaudio-ctl full-status | wc -c) ]
then
	volnoti-show -m
else
	volnoti-show $(echo `pulseaudio-ctl current` | tr -d %)
fi
