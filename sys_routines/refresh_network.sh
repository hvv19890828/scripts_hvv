#!/bin/bash
stateofAC=$(cat /sys/class/power_supply/ACAD/online)
#verification
if (( $stateofAC == 1 ));
then
ssh -i /root/.ssh/id_rsa -q hvv@hvv19890828.ddns.net -p 55399 exit
stateof101=$(echo $?) #curl --interface enx000ec79ecb52 -m 5 http://www.google.com/ | grep -i google | wc -l)
ssh -i /root/.ssh/id_rsa -q hvv@hvv19890828.ddns.net -p 55299 exit
stateof100=$(echo $?) #curl --interface wlp2s0 -m 5 http://www.google.com/ | grep -i google | wc -l)
if (( $stateof100 < 1 && $stateof101 < 1 )); #&& $stateof101 > 0
then
echo 0 > /scripts_hvv/sys_routines/if_tries_count
fi
if (( $stateof100 < 1 ));
then
echo 0 > /scripts_hvv/sys_routines/if_tries_count100
fi
if (( $stateof101 < 1 ));
then
echo 0 > /scripts_hvv/sys_routines/if_tries_count101
fi
if_tries_counter=$(cat /scripts_hvv/sys_routines/if_tries_count)
if_tries_counter100=$(cat /scripts_hvv/sys_routines/if_tries_count100)
if_tries_counter101=$(cat /scripts_hvv/sys_routines/if_tries_count101)

#service connection refresh

if (( $stateof100 > 0 ));
then
if (( $if_tries_counter100 >= 3 && $if_tries_counter < 3 ));
then
let "if_tries_counter=if_tries_counter+1"
echo $if_tries_counter > /scripts_hvv/sys_routines/if_tries_count
#reset of the indevidual network interfaces counters
echo 0 > /scripts_hvv/sys_routines/if_tries_count100
echo 0 > /scripts_hvv/sys_routines/if_tries_count101
#reset of the individual network interfaces counters
/scripts_hvv/sys_routines/gracefull_system_restart.sh
else
ip link set wlp2s0 down ; sleep 2
modprobe -r iwlwifi
chmod -R 777 /sys/bus/pci
chmod -R 777 /sys/bus/pci/devices/0000:02:00.0 ; sleep 2
echo 1 > /sys/bus/pci/devices/0000:02:00.0/remove ; sleep 2
echo 1 > /sys/bus/pci/rescan ; sleep 2
modprobe iwlwifi ; sleep 2
ip link set wlp2s0 up ; sleep 5
sudo service ssh restart
#
#vvmstat=$(vagrant global-status | grep host | wc -l)
#let "vvmstat=vvmstat+1"
#is=1
#nodex=host
#while [[ $is < $vvmstat ]]
#do
#tmps=$nodex$is
#cd /scripts_hvv/vmprov/vagrant/ && vagrant suspend $tmps && sleep 5
#let "is=is+1"
#done
#
#ir=1
#while [[ $ir < $vvmstat ]]
#do
#tmpr=$nodex$ir
#cd /scripts_hvv/vmprov/vagrant/ && vagrant resume $tmpr && sleep 1
#let "ir=ir+1"
#done
#
let "if_tries_counter100=if_tries_counter100+1"
echo $if_tries_counter100 > /scripts_hvv/sys_routines/if_tries_count100
fi
fi

#data connection refresh

if (( $stateof101 > 1 ));
then
if (( $if_tries_counter101 >= 3 && $if_tries_counter < 3 ));
then
let "if_tries_counter=if_tries_counter+1"
echo $if_tries_counter > /scripts_hvv/sys_routines/if_tries_count
#reset of the indevidual network interfaces counters
echo 0 > /scripts_hvv/sys_routines/if_tries_count100
echo 0 > /scripts_hvv/sys_routines/if_tries_count101
#reset of the individual network interfaces counters
/scripts_hvv/sys_routines/gracefull_system_restart.sh
else
ip link set enx000ec79ecb52 down ; sleep 2
#ip link set wlx502b73d80f39 down
#ip link set wlx00e0262e336b down
modprobe -r ax88179_178a
#modprobe -r 8812au
#modprobe -r rtl8188fu
chmod -R 777 /sys/bus/pci
chmod -R 777 /sys/bus/pci/devices/0000:00:14.0 ; sleep 2
echo 1 > /sys/bus/pci/devices/0000:00:14.0/remove ; sleep 2
echo 1 > /sys/bus/pci/rescan ; sleep 2
modprobe ax88179_178a ; sleep 2
#modprobe 8812au
#modprobe rtl8188fu
ip link set enx000ec79ecb52 up
#ip link set wlx502b73d80f39 up
#ip link set wlx00e0262e336b up
sudo service ssh restart
let "if_tries_counter101=if_tries_counter101+1"
echo $if_tries_counter101 > /scripts_hvv/sys_routines/if_tries_count101
fi
fi
fi
