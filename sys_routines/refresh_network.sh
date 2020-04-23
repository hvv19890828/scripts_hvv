#!/bin/bash

#vars initialization

stateof101=$(curl --interface wlx502b73d80f39 -m 1 192.168.0.1:55099 | grep -i archer | wc -l)
stateof100=$(curl --interface wlp2s0 -m 1 192.168.0.1:55099 | grep -i archer | wc -l)
if (( $stateof100 > 0 && $stateof101 > 0 ));
then
echo 0 > /scripts_hvv/sys_routines/if_tries_count
fi
if (( $stateof100 > 0 ));
then
echo 0 > /scripts_hvv/sys_routines/if_tries_count100
fi
if (( $stateof101 > 0 ));
then
echo 0 > /scripts_hvv/sys_routines/if_tries_count101
fi
if_tries_counter=$(cat /scripts_hvv/sys_routines/if_tries_count)
if_tries_counter100=$(cat /scripts_hvv/sys_routines/if_tries_count100)
if_tries_counter101=$(cat /scripts_hvv/sys_routines/if_tries_count101)

#service connection refresh

if (( $stateof100 < 1 && $if_tries_counter < 3 ));
then
if (( $if_tries_counter100 >= 2 ));
then
let "if_tries_counter=if_tries_counter+1"
echo $if_tries_counter > /scripts_hvv/sys_routines/if_tries_count
#reset of the indevidual network interfaces counters
echo 0 > /scripts_hvv/sys_routines/if_tries_count100
echo 0 > /scripts_hvv/sys_routines/if_tries_count101
#reset of the individual network interfaces counters
/scripts_hvv/sys_routines/gracefull_system_restart.sh
else
ip link set wlp2s0 down
sleep 2
modprobe -r iwlwifi
chmod -R 777 /sys/bus/pci
chmod -R 777 /sys/bus/pci/devices/0000:02:00.0
sleep 2
echo 1 > /sys/bus/pci/devices/0000:02:00.0/remove
sleep 2
echo 1 > /sys/bus/pci/rescan
sleep 2
modprobe iwlwifi
sleep 2
ip link set wlp2s0 up
let "if_tries_counter100=if_tries_counter100+1"
echo $if_tries_counter100 > /scripts_hvv/sys_routines/if_tries_count100
fi
fi

#data connection refresh

if (( $stateof101 < 1 && $if_tries_counter < 3 ));
then
if (( $if_tries_counter101 >= 2 ));
then
let "if_tries_counter=if_tries_counter+1"
echo $if_tries_counter > /scripts_hvv/sys_routines/if_tries_count
#reset of the indevidual network interfaces counters
echo 0 > /scripts_hvv/sys_routines/if_tries_count100
echo 0 > /scripts_hvv/sys_routines/if_tries_count101
#reset of the individual network interfaces counters
/scripts_hvv/sys_routines/gracefull_system_restart.sh
else
ip link set wlx502b73d80f39 down
ip link set wlx00e0262e336b down
sleep 2
modprobe -r 8812au
modprobe -r rtl8188fu
chmod -R 777 /sys/bus/pci
chmod -R 777 /sys/bus/pci/devices/0000:00:14.0
sleep 2
echo 1 > /sys/bus/pci/devices/0000:00:14.0/remove
sleep 2
echo 1 > /sys/bus/pci/rescan
sleep 2
modprobe 8812au
modprobe rtl8188fu
sleep 2
ip link set wlx502b73d80f39 up
ip link set wlx00e0262e336b up
sleep 5
cd /scripts_hvv/vmprov/vagrant/
vagrant suspend
vagrant resume
let "if_tries_counter101=if_tries_counter101+1"
echo $if_tries_counter101 > /scripts_hvv/sys_routines/if_tries_count101
fi
fi
