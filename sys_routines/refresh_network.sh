#!/bin/bash

#vars initialization

i=0
stateof102=$(curl --interface wlx00e0262e336b --connect-timeout 2 192.168.0.1:55099 | grep -i archer | wc -l)
stateof101=$(curl --interface wlx502b73d80f39 --connect-timeout 2 192.168.0.1:55099 | grep -i archer | wc -l)
stateof100=$(curl --interface wlp2s0 --connect-timeout 2 192.168.0.1:55099 | grep -i archer | wc -l)
if (( $stateof100 > 0 || $stateof101 > 0 || $stateof102 > 0 ));
then
echo 0 > /scripts_hvv/sys_routines/if_tries_count
fi
if_tries_counter=$(cat /scripts_hvv/sys_routines/if_tries_count)

#service connection

if [[ $stateof100 < 1 ]]
then
modprobe -r iwlwifi
chmod -R 777 /sys/bus/pci
chmod -R 777 /sys/bus/pci/devices/0000:02:00.0
sleep 2
echo 1 > /sys/bus/pci/devices/0000:02:00.0/remove
sleep 2
echo 1 > /sys/bus/pci/rescan
sleep 2
modprobe iwlwifi
fi

#data connection

if [[ $stateof101 < 1 ]]
then
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
sleep 2
modprobe rtl8188fu
fi

#secondary remedy

if (( $if_tries_counter < 3 && $stateof100 < 1 && $stateof101 < 1 && $stateof102 < 1 ));
then
ip link set wlp2s0 down
sleep 2
ip link set wlp2s0 up
ip link set wlx502b73d80f39 down
sleep 2
ip link set wlx502b73d80f39 up
ip link set wlx00e0262e336b down
sleep 2
ip link set wlx00e0262e336b up
while (( $i <= 180 ));
do
sleep 1
if (( $i >= 180 ));
then
if (( $( curl --interface wlx00e0262e336b --connect-timeout 2 hvv19890828.ddns.net:55099 | grep -i archer | wc -l ) < 1 && $(curl --interface wlx502b73d80f39 --connect-timeout 2 hvv19890828.ddns.net:55099 | grep -i archer | wc -l) < 1 && $(curl --interface wlp2s0 --connect-timeout 2 hvv19890828.ddns.net:55099 | grep -i archer | wc -l) ));
then
let "if_tries_counter=if_tries_counter+1"
echo $if_tries_counter > /scripts_hvv/sys_routines/if_tries_count
/scripts_hvv/sys_routines/gracefull_system_restart.sh
fi
fi
let "i=i+1"
done
fi
