#!/bin/bash

echo "Hello!"
sleep 3
echo "Lets set up the daemon for you."
sleep 3
echo "Do you want to turn the daemon on, off, or exit the script?"
echo "1) on"
echo "2) off"
echo "3) exit"
read r
if [[ "$r" = [1-3] ]]
then
	case $r in
		1)
			sudo systemctl enable wg-quick@wg0
			wait
			echo "wireguard enabled"
			;;

		2)
			sudo systemctl disable wg-quick@wg0
			wait
			echo "wireguard disabled"
			;;

		3)
			exit
			;;
	esac
fi
