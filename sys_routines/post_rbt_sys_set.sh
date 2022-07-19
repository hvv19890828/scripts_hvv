#!/bin/bash
#vars initialization
stateofsdb1=$(blkid | grep bf1c6e60-fd77-4877-bf6e-d0db3dc1fe99 | wc -l)
#verification
sleep 30
if (( $stateofsdb1 == 1 ));
then
mount /dev/sdb /bckp_hvv
chmod -R 777 /bckp_hvv
vvmstatr=$(vagrant global-status | grep host | wc -l)
let "vvmstatr=vvmstatr+1"
ir=1
noder=host
while [[ $ir < $vvmstatr ]]
do
tmpr=$noder$ir
cd /scripts_hvv/vmprov/vagrant/ && vagrant resume $tmpr && sleep 1
let "ir=ir+1"
done
sleep 5
/scripts_hvv/sys_routines/firewall-setup.sh
#
else
sleep 20
/scripts_hvv/sys_routines/gracefull_system_restart.sh
fi
