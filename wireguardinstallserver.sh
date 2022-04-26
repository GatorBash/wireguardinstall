#!/bin/bash

key=$(cat privatekey)
dir='/etc/wireguard'

echo "Are you logged in as root? y or n."
read r
if [ $r = y ]
then
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
	cd /etc/wireguard
	umask 077
	wg genkey | tee privatekey | wg pubkey > publickey
	touch wg0.conf
	echo "[Interface]" >> wg0.conf
	echo "PrivateKey = $key" >> wg0.conf
	echo "Address = <personalized private ip>" >> wg0.conf
	echo "ListenPort = 65535" >> wg0.conf
	echo "Adding some IPtables BS."
	echo "PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> wg0.conf
	echo "PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE" >> wg0.conf
	echo " " >> wg0.conf
	echo "[Peer]" >> wg0.conf
	echo "PublicKey = <client public key>" >> wg0.conf
	echo "AllowedIPs = <personalized private ip>" >> wg0.conf
	echo "Make sure that you use private ip address ranges for your ips and use a cidr of /32"
	sleep 3
	clear
	echo "Done GLHF!"
	else
		echo "Sign into root using 'sudo -i' and run the script again"
		exit
fi

