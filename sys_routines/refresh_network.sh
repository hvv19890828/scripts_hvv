#!/bin/bash
#vars initialization
i=0
stateof102=$(ifconfig | grep -A4 wlx00e0262e336b | grep "inet 1" | wc -l)
stateof101=$(ifconfig | grep -A4 wlx502b73d80f39 | grep "inet 1" | wc -l)
stateof100=$(ifconfig | grep -A4 wlp2s0 | grep "inet 1" | wc -l)
pingVia102=$(ping -c 1 -I wlx00e0262e336b 8.8.8.8 | grep "PING" | wc -l)
pingVia101=$(ping -c 1 -I wlx502b73d80f39 8.8.8.8 | grep "PING" | wc -l)
pingVia100=$(ping -c 1 -I wlp2s0 8.8.8.8 | grep "PING" | wc -l)
if (( $pingVia100 == 1 || $pingVia101 == 1 || $pingVia102 == 1 ));
then
echo 0 > /scripts_hvv/sys_routines/if_tries_count
fi
if_tries_counter=$(cat /scripts_hvv/sys_routines/if_tries_count)
#service connection
if [[ $stateof100 != 1 || $pingVia100 != 1  ]]
then
modprobe -r iwlwifi
chmod -R 777 /sys/bus/pci
chmod -R 777 /sys/bus/pci/devices/0000:02:00.0
echo 1 > /sys/bus/pci/devices/0000:02:00.0/remove
echo 1 > /sys/bus/pci/rescan
modprobe iwlwifi
fi
#data connection
if [[ $stateof101 != 1 || $stateof102 != 1 || $pingVia101 != 1 || $pingVia102 != 1 ]]
then
modprobe -r 8812au && modprobe -r rtl8188fu
chmod -R 777 /sys/bus/pci
chmod -R 777 /sys/bus/pci/devices/0000:00:14.0
echo 1 > /sys/bus/pci/devices/0000:00:14.0/remove
echo 1 > /sys/bus/pci/rescan
modprobe 8812au && modprobe rtl8188fu
fi
#secondary remedy
if (( $if_tries_counter < 3 && $pingVia100 != 1 && $pingVia101 != 1 && $pingVia102 != 1 ));
then
while (( $i <= 180 ));
do
sleep 1
if (( $i >= 180 ));
then
if (( $(ping -c 1 -I wlx00e0262e336b 8.8.8.8 | grep "PING" | wc -l) != 1 && $(ping -c 1 -I wlx502b73d80f39  8.8.8.8 | grep "PING" | wc -l) != 1 && $(ping -c 1 -I wlp2s0 8.8.8.8 | grep "PING" | wc -l) != 1 ));
then
let "if_tries_counter=if_tries_counter+1"
echo $if_tries_counter > /scripts_hvv/sys_routines/if_tries_count
reboot
fi
fi
let "i=i+1"
done
fi
