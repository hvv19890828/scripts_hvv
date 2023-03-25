#!/bin/bash
#vars initialization
stateofsdb1=$(blkid | grep d91e3790-9770-4dba-8dbe-ed54a5eb38e6 | wc -l)
stateofAC=$(cat /sys/class/power_supply/ACAD/online)
#verification
if (( $stateofAC == 1 ));
then
if (( $stateofsdb1 == 1 ));
then
mount /dev/sdb1 /bckp_hvv
chmod -R 777 /bckp_hvv
#
else
/scripts_hvv/sys_routines/gracefull_system_restart.sh
fi
fi
