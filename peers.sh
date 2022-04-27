#!/bin/bash

#this is ment to be used to create more peers in the wireguard servers config file
file=/etc/wireguard/wg0.conf
#dir=/etc/wireguard
pubkey=$(cat "$pub")

echo "Are you logged in as root? y/n "
read -r rep
if [ $rep == n ]
then
	echo "Sign into root using \"sudo -i \""
else
	clear
	echo "Since you're here, I'm guessing that you want to add some more peers to your serverconfig file."
	echo "Is that true? y/n"
	read peer
	while [ "$peer" == y ]
	do
		echo "Ok lets do this?"
		umask 077
		echo "What IP do you want to use for your client? Include the CIDR."
		read -r ip
		echo "Do you have the public key for the client? y/n"
		read -r c
		if [ "$c" == n ]
		then
			echo "Ok you will have to add it to the file later"
		else
			echo "2ez what is the absolute path to the file?"
			read -r pub
		fi
		if [ "$c" == n ]
		then
			echo " " >> $file
			sleep 1
			echo "[Peer]" >> $file
			sleep 1
			echo "PublicKey = <client pub key>" >> $file
			sleep 1
			echo "AllowedIPs = $ip" >> $file
		else
			echo " " >> $file
			sleep 1
			echo "[Peer]" >> $file
			sleep 1
			echo "PublicKey = $pubkey" >> $file
			sleep 1
			echo "AllowedIPs = $ip" >> $file
		fi
		echo "Do you want to make another peer for your config? y/n"
		read -r peer
	done
fi
echo "Ok that should do it GLHF"
