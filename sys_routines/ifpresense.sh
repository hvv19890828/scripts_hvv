#!/bin/bash

#vars initialization

presenseof102=$(lsmod | grep rtl8188fu | wc -l)
presenseof101=$(lsmod | grep 8812au | wc -l)
stateofbckp_hvv=$(lsblk | grep bckp_hvv | wc -l)
if_try_counter=$(cat /scripts_hvv/sys_routines/if_tries_count)

#data connection

if (( $presenseof101 < 1 ));
then
if (( $stateofbckp_hvv >= 1 && $if_try_counter >= 3 ));
then
if (( $(curl -m 1 192.168.0.1:55099 | grep -i archer | wc -l) >= 1 ));
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
sleep 10
/scripts_hvv/sys_routines/gracefull_system_restart.sh
fi
fi
fi

#widi connection

if (( $presenseof102 < 1 ));
then
if (( $stateofbckp_hvv >= 1 && $(curl --interface wlx502b73d80f39 -m 1 192.168.0.1:55099 | grep -i archer | wc -l) > 0 && $(curl --interface wlp2s0 -m 1 192.168.0.1:55099 | grep -i archer | wc -l) > 0 ));
then
echo -ne '\n' | sudo add-apt-repository ppa:kelebek333/kablosuz
sudo apt-get update
sudo apt install -y rtl8188fu-dkms
fi
fi
