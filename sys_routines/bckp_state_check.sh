#!/bin/bash
#vars initialization
stateofsdb1=$(blkid | grep 18a7afb1-7a0f-4904-8c97-95120cb32823 | wc -l)
#verification
sleep 30
if (( $stateofsdb1 == 1 ));
then
mount /dev/sdb1 /bckp_hvv/
chmod -R 777 /bckp_hvv
#refresh_network.sh related (reset of the indevidual network interfaces counters)
echo 0 > /scripts_hvv/sys_routines/if_tries_count100
echo 0 > /scripts_hvv/sys_routines/if_tries_count101
#refresh_network.sh related (reset of the individual network interfaces counters)
else
sleep 20
/scripts_hvv/sys_routines/gracefull_system_restart.sh
fi
