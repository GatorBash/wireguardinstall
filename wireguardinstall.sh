#!/bin/bash

key=$(cat privatekey)
old_key='PrivateKey = '
dir='/etc/wireguard'

echo "Are you logged in as root? y or n "
read r
if [ $r = y ]
then
echo "ok we are gonna make this nice"
sleep 3
echo "and...."
sleep 3
echo "easy"
sleep 5
echo "First we're going to update and install some things"
echo "Get ready to put in your password"
sudo apt update -y
wait
sudo apt install wireguard wireguard-dkms wireguard-tools -y
wait
echo "Hopefully that didn't error out"
sleep 5
echo "get ready for your password again"
cd /etc/wireguard
umask 077
wg genkey | tee privatekey | wg pubkey > publickey
touch wg0.conf
echo "[Interface]" >> wg0.conf
echo "PrivateKey = " >> wg0.conf
echo "Address = " >> wg0.conf
echo "[Peer]" >> wg0.conf
echo "PublicKey = sgCy0AVDqUwsbp/fZl/dNWSy1RLLNEb4BiCF2TukiXA=" >> wg0.conf
echo "AllowedIPs = 0.0.0.0/0" >> wg0.conf
echo "Endpoint = 137.184.151.23:55234" >> wg0.conf
echo "PersistentKeepalive = 25"
sed -i "/$old_key/c\\$old_key$key" wg0.conf
else
	echo "sign into root using 'sudo -i'"
	exit
fi
