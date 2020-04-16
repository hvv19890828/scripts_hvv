#!/bin/bash

#vars initialization

presenseof102=$(ifconfig | grep wlx00e0262e336b | wc -l)
presenseof101=$(ifconfig | grep wlx502b73d80f39 | wc -l)
stateofbckp_hvv=$(lsblk | grep bckp_hvv | wc -l)


#data connection

if (( $presenseof101 != 1 ));
then
if (( $stateofbckp_hvv == 1 ));
then
apt-get install -y linux-headers-$(uname -r)
apt-get install -y build-essential git dkms libelf-dev
rm -r /scripts_hvv/sys_routines/rtl8812au/
mkdir /scripts_hvv/sys_routines/rtl8812au/
git clone https://github.com/gordboy/rtl8812au.git /scripts_hvv/sys_routines/rtl8812au
cd /scripts_hvv/sys_routines/rtl8812au
make
make install
modprobe 8812au
fi
fi

#widi connection

if (( $presenseof102 != 1 ));
then
if (( $stateofbckp_hvv == 1 ));
then
echo -ne '\n' | sudo add-apt-repository ppa:kelebek333/kablosuz
sudo apt-get update
sudo apt install -y rtl8188fu-dkms
fi
fi
