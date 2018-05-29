#!/usr/bin/env bash

interface="rtl8723be"

if [[ `lsmod | grep -E "^rtl8723be" -o` = "$interface" ]]
then
	echo "Driver is loaded."
	sudo rmmod $interface
	sudo modprobe $interface
else
	echo "Driver not loaded."
	echo "Doing Modprobe."
	sudo modprobe $interface
fi

interface=$(rfkill list | grep -E "(LAN)" | grep -E "^[0-9]" -o)
for x in $interface;
do
	rfkill unblock $x
done
