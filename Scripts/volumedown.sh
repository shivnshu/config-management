#!/bin/bash

pulseaudio-ctl down 5
volnoti-show $(echo `pulseaudio-ctl current` | tr -d %)
