#!/bin/bash
#vars initialization
stateofbckp_hvv=$(lsblk | grep bckp_hvv | wc -l)
#verification
if (( $stateofbckp_hvv == 1 ));
then
rsync -a --delete /home/hvv/Downloads/ /bckp_hvv/Downloads
fi
