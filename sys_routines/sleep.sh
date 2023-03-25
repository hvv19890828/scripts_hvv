#!/bin/bash
#vars initialization
stateofAC=$(cat /sys/class/power_supply/ACAD/online)
#action
if (( $stateofAC == 0 ));
then
vVMRunningState=$(vagrant global-status | grep "virtualbox running" | wc -l)
if (( $vVMRunningState != 0 ));
then
/scripts_hvv/sys_routines/vagrant_suspend.sh
fi
rtcwake -m mem -s 7200
fi
#
if (( $stateofAC == 1 ));
then
vVMSavedState=$(vagrant global-status | grep "virtualbox saved" | wc -l)
if (( $vVMSavedState != 0 ));
then
sleep 60
/scripts_hvv/sys_routines/firewall-setup.sh
/scripts_hvv/sys_routines/vagrant_resume.sh
fi
fi

