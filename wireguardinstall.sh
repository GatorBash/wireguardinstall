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
cd /etc/wireguard
umask 077
wg genkey | tee privatekey | wg pubkey > publickey
touch wg0.conf
echo "[Interface]" >> wg0.conf
echo "PrivateKey = " >> wg0.conf
echo "Address = " >> wg0.conf
echo "[Peer]" >> wg0.conf
echo "PublicKey = <server public key" >> wg0.conf
echo "AllowedIPs = 0.0.0.0/0" >> wg0.conf
echo "Endpoint = <server public ip:port>" >> wg0.conf
echo "PersistentKeepalive = 25"
#the sed command is ment to add in your private key to the config file but it has been hit or miss
sed -i "/$old_key/c\\$old_key$key" wg0.conf
else
	echo "sign into root using 'sudo -i' and run the script again."
	exit
fi
