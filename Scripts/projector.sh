#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=/home/shivnshu/.Xauthority

function connect()
{
    xrandr --output HDMI1 --left-of eDP1 --preferred --primary --output eDP1 --preferred
    echo "Connected"
}

function disconnect()
{
    xrandr --output HDMI1 --off
    echo "Disconnected"
}

xrandr | grep "HDMI1 connected" &> /dev/null && connect || disconnect
