#!/bin/bash
echo "**************************************************" && ls -altX && echo "**************************************************" && pwd && echo "**************************************************"
echo " ... and so welcome again HVV ..."
echo " ... would you like to check for updates(y / any input)? ... "
read input
if [[ $input == y ]]
then
sudo apt-get update -y && sudo apt-get upgrade -y
fi
echo "REMINDER: Use 'rbt' for graceful reboot, use 'vvmdel' for complete vagrant VMs removal and 'vvmup' as an equivalent of 'vagrant up', use 'l' for handy directory listing, use 'k8s' to bring up a cluster".
