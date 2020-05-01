#!/bin/bash
#vars initialization
vvmstats=$(vagrant global-status | grep node | wc -l)
let "vvmstats=vvmstats+1"
is=1
nodes=node
while [[ $is < $vvmstats ]]
do
tmps=$nodes$is
cd /scripts_hvv/vmprov/vagrant/ && vagrant suspend $tmps
sleep 1
let "is=is+1"
done
