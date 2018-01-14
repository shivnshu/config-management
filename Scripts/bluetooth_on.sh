#!/bin/bash

interface=$(rfkill list | grep -E "(Bluetooth)" | grep -E "^[0-9]" -o)
for x in $interface;
do
	rfkill unblock $x
done
