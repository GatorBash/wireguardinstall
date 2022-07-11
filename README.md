# WireguardInstall

I've made several scripts posted here to make life a little better.
I hope you find it helpful

# Requirements 

This set of scripts is intended to be used on Debian based computers.
If you aren't using Debian you'll need to change the package manager.
Of course you'll also need an internet connection.

# How to use this

You'll need to do just a couple of things.
- Make sure you're logged in as root.  You can do this with `sudo -i`
- Ensure that you're connected to the internet.
- **Before** you do anything you will need to `cd` into the wireguardinstall directory.

## Client

- you will need to make the install script exitcutable.
- `chmod +x  wireguardinstall.sh`
- To run it run the next command
- `./wireguardinstall.sh`

## Server
- You will need to make the install scipt exicutable.
- `chmod +x wireguardinstallserver.sh`
- To run it run the next command
- `./wireguardinstallserver.sh`


# Need to Know



# Issues

- need to add ifmetric script to dispatcher.d
**ifmetric script added to client install**
- fullwginstall.sh doesn't work yet
**depricated fullwginstall**

If you have any issues please let me know so I can get'em fixed.

