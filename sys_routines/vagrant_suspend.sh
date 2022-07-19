#!/bin/bash
#vars initialization
vvmstats=$(vagrant global-status | grep host | wc -l)
let "vvmstats=vvmstats+1"
is=1
nodes=host
while [[ $is < $vvmstats ]]
do
tmps=$nodes$is
cd /scripts_hvv/vmprov/vagrant/ && vagrant suspend $tmps
sleep 1
let "is=is+1"
done
