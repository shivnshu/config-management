#!/bin/bash

interface=$(rfkill list | grep -E "(LAN)" | grep -E "^[0-9]" -o)

for x in $interface;
do
	rfkill block $x
done
