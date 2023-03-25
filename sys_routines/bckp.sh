#!/bin/bash
#vars initialization
stateofbckp_hvv=$(lsblk | grep bckp_hvv | wc -l)
stateofAC=$(cat /sys/class/power_supply/ACAD/online)
#verification
if (( $stateofAC == 1 ));
then
if (( $stateofbckp_hvv == 1 ));
then
chmod -R 777 /home/hvv/Downloads/
chmod -R 777 /bckp_hvv/Downloads/
rsync -a --delete /home/hvv/Downloads/ /bckp_hvv/Downloads
fi
fi

