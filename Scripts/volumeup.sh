#!/bin/bash

# Depend:
#	https://github.com/davidbrazdil/volnoti
#	https://github.com/graysky2/pulseaudio-ctl

pulseaudio-ctl up 5
volnoti-show $(echo `pulseaudio-ctl current` | tr -d %)
