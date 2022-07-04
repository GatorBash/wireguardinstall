#!/bin/bash

dir=/etc/wireguard

#this ensures the user is root
if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root; run \"sudo -i\" this will log you into root." 
   exit 1
else
	echo "Here comes your server install"
	sleep 3
	clear
	echo "First we are going to do an update and an install."
	sleep 3
	clear
	sudo apt update -y
	wait
	sudo apt install wireguard wireguard-tools wirguard-dkms
	wait
	clear
	echo "Making keys and configuration file."
	sleep 5
	cd $dir
	umask 077
	wg genkey | tee privatekey | wg pubkey > publickey
	key=$(cat privatekey)
	touch wg0.conf
	echo "[Interface]" >> wg0.conf
	echo "PrivateKey = ""$key""" >> wg0.conf
	echo "Address = <personalized private ip>" >> wg0.conf
	echo "ListenPort = 65535" >> wg0.conf
	echo "Adding some IPtables BS."
	echo "PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; iptables -A FORWARD -i wg0 -o wg0 -j ACCEPT" >> wg0.conf
	echo "PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE" >> wg0.conf
	echo " " >> wg0.conf
	echo "[Peer]" >> wg0.conf
	echo "PublicKey = <client public key>" >> wg0.conf
	echo "AllowedIPs = <personalized private ip>" >> wg0.conf
	echo "Make sure that you use private ip address ranges for your ips and use a cidr of /32"
	sleep 3
	clear
	echo "Done GLHF!"
fi
echo "Do you want to add more Peers to your config?"
echo "y/n"
read -r peer
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
		echo " " >> $file
		sleep 1
		echo "[Peer]" >> $file
		sleep 1
		echo "PublicKey = <client pub key>" >> $file
		sleep 1
		echo "AllowedIPs = $ip" >> $file
	else
		echo "2ez what is the absolute path to the file?"
		read -r pub
		pubkey=$(cat "$pub")
		echo " " >> $file
		sleep 1
		echo "[Peer]" >> $file
		sleep 1
		echo "PublicKey = ""$pubkey""" >> $file
		sleep 1
		echo "AllowedIPs = ""$ip""" >> $file
	fi
	echo "Do you want to make another peer for your config? y/n"
	read -r peer
done
echo "Ok that should do it GLHF"
