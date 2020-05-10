#!/bin/bash
#vars initialization
stateofsdb1=$(blkid | grep 18a7afb1-7a0f-4904-8c97-95120cb32823 | wc -l)
#verification
sleep 30
if (( $stateofsdb1 == 1 ));
then
mount /dev/sdb1 /bckp_hvv/
chmod -R 777 /bckp_hvv
#
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
#
else
sleep 20
/scripts_hvv/sys_routines/gracefull_system_restart.sh
fi
