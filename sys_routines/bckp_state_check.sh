#!/bin/bash
#vars initialization
stateofsdb1=$(blkid | grep 18a7afb1-7a0f-4904-8c97-95120cb32823 | wc -l)
#verification
sleep 30
if (( $stateofsdb1 == 1 ));
then
mount /dev/sdb1 /bckp_hvv/
chmod -R 777 /bckp_hvv
cd /scripts_hvv/vmprov/vagrant/
vagrant resume
else
sleep 20
/scripts_hvv/sys_routines/gracefull_system_restart.sh
fi
