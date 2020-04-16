#!/bin/bash
echo "**************************************************" && ls -altX && echo "**************************************************" && pwd && echo "**************************************************"
echo " ... and so welcome again HVV ..."
echo " ... would you like to check for updates(y / any input)? ... "
read input
if [[ $input == y ]]
then
sudo apt update -y && sudo apt upgrade -y
fi
echo "REMINDER: Use 'rbt' for graceful reboot, use 'vvmdell' for complete vagrant VMs removal, use 'l' for handy directory listing "
