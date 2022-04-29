#!/bin/bash

key=$(cat privatekey)
#old_key='PrivateKey = '
#dir='/etc/wireguard'

if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root; run \"sudo -i\" this will log you into root." 
   exit 1
else
	echo "ok we are gonna make this nice"
	sleep 3
	echo "and...."
	sleep 3
	echo "easy"
	sleep 5
	echo "First we're going to update and install some things"
	apt update -y
	wait
	apt install wireguard wireguard-dkms wireguard-tools -y
	wait
	apt install ifmetric
	clear
	echo "Hopefully that didn't error out"
	sleep 5
	cd /etc/wireguard
	umask 077
	wg genkey | tee privatekey | wg pubkey > publickey
	touch wg0.conf
	echo "what is the ip of your server?"
	read -r server
	echo "what port are you using for your server?"
	read -r port
	echo "What IP are you going to use for your client?"
	read -r client
	echo "[Interface]" >> wg0.conf
	echo "PrivateKey = $key" >> wg0.conf
	sleep 1
	echo "Address = $client" >> wg0.conf
	sleep 1
	echo "Do you have the publickey file? y/n"
	read -r rep
	if [ "$rep" = n ]
	then
		echo "[Peer]" >> wg0.conf
		echo "PublicKey = <server public key>" >> wg0.conf
		echo "AllowedIPs = 0.0.0.0/0" >> wg0.conf
		echo "Endpoint = $server:$port" >> wg0.conf
		sleep 1
		echo "PersistentKeepalive = 25" >> wg0.conf
	else
		echo "Type in the absolute path to the public key file"
		read -r pub
		pubkey=$(cat "$pub")
		echo "[Peer]" >> wg0.conf
		echo "PublicKey = ""$pubkey""" >> wg0.conf
		echo "AllowedIPs = 0.0.0.0/0" >> wg0.conf
		echo "Endpoint = ""$server"":""$port""" >> wg0.conf
		sleep 1
		echo "PersistentKeepalive = 25" >> wg0.conf
	fi
#the sed command is ment to add in your private key to the config file but it has been hit or miss
#sed -i "/$old_key/c\\$old_key$key" wg0.conf
fi
