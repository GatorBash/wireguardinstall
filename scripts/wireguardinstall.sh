#!/bin/bash

#old_key='PrivateKey = '
dir='/etc/wireguard'

if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root; run \"sudo -i\" this will log you into root." 
   exit 1
else
	echo "First we're going to update and install some things"
	sleep 5
	apt update -y
	wait
	apt install wireguard -y
	wait
	apt install wireguard-dkms -y
	wait
	apt install wireguard-tools -y
	wait
	apt install ifmetric -y
	wait
	clear
	echo "Hopefully that didn't error out"
	sleep 5
	umask 077
	wg genkey | tee $dir/privatekey | wg pubkey > $dir/publickey
	key=$(cat $dir/privatekey)
	touch wg0.conf
	echo "what is the ip of your server?"
	read -r server
	echo "what port are you using for your server?"
	read -r port
	echo "What IP are you going to use for your client?"
	read -r client
	echo "[Interface]" >> $dir/wg0.conf
	sleep 1
	echo "PrivateKey = $key" >> $dir/wg0.conf
	sleep 1
	echo "Address = $client/32" >> $dir/wg0.conf
	sleep 1
	echo " " >> $dir/wg0.conf
	sleep 1
	echo "Do you have the publickey file? y/n"
	read -r rep
	if [ "$rep" == n ]
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

#Set up ifmetric for a cell hat
echo "Are you using a cell hat? y/n"
read -r cell
if [ "$cell" == y ]
then
	cellsh=/etc/NetworkManager/dispatcher.d/set_metrics.sh
	touch $cellsh	
	echo "#!/bin/bash/" >> $cellsh
	echo " " >> $cellsh
	echo "ifmetric wwan0 1" >> $cellsh
	echo "ifmetric usb0 2" >> $cellsh
	echo "ifmetric wg0 3" >> $cellsh
	echo "ifmetric wlan1 10" >> $cellsh
	echo "ifmetric wlan0 20" >> $cellsh
	echo "ifmetric eth0 700" >> $cellsh
	chmod +x $cellsh
fi

echo "Do you want wireguard to start when the device come on? y/n"
read -r service
if [ "$service" == y ]
then
	echo "Ok we are gonna Daemonize this too. Let's go"
	sleep 3
	systemctl enable wg-quick@wg0
	wait
	echo "Wireguard service created."
	systemctl start wg-quick@wg0
	wait
	echo "Wireguard service started."
fi
#write logs to ram
#wget https://github.com/azlux/log2ram/archive/master.tar.gz -O log2ram.tar.gz
#wait
#tar xf log2ram.tar.gz
#cd log2ram-master
#./install
#wait

wait

sleep 3
echo "That's it for now."
echo "GLHF"
exit 0
