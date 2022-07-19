#!/bin/bash
#vars initialization
vvmstatr=$(vagrant global-status | grep host | wc -l)
let "vvmstatr=vvmstatr+1"
ir=1
noder=host
while [[ $ir < $vvmstatr ]]
do
tmpr=$noder$ir
cd /scripts_hvv/vmprov/vagrant/ && vagrant resume $tmpr
sleep 1
let "ir=ir+1"
done
