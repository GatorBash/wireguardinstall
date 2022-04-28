#!/bin/bash

#this ensures the user is root
if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root; run \"sudo -i\" this will log you into root." 
   exit 1
fi
chomod +x *
echo "Are you running this on the server or the client?"
read -r dev
if [ "$dev" == client ]
then
	echo "Ok we will just run a couple of scripts real quick."
	./wireguardinstall.sh
	wait
	./wireguarddaemon.sh
	wait
	echo "Ok go back and make sure everything is in the right place."
	echo "GLHF"
elif [ "$dev" == server ]
then
	echo "Ok we are just going to run a couple of scripts."
	./wireguardinstallserver.sh
	wait
	./wireguardpeers.sh
	wait
	echo "With all that you should be set up."
	echo "GLHF"
else
	echo "Fully type out client or server"
fi
