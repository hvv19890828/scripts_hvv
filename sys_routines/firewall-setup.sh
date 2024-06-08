#!/bin/bash

#Enable port forwarding by editing the sysctl.conf file. I assume “net.ipv4.ip_forward” is commented in the /etc/sysctl.conf file:
#nano /etc/sysctl.conf
#Add or find and uncomment the following line
#net.ipv4.ip_forward=1
#Save, close the file and run the following command to make the changes take effect.
#sysctl -p

#pidor
iptables -A INPUT -s 222.122.202.149 -j DROP
iptables -A FORWARD -s 222.122.202.149 -j DROP
iptables -A OUTPUT -d 222.122.202.149 -j DROP
iptables -A FORWARD -d 222.122.202.149 -j DROP
#pidor
#VM subnet setup
ip link set vboxnet1 up
ip addr add 192.168.6.1/24 dev vboxnet1
ip route add 192.168.6.0/24 dev vboxnet1
iptables --table nat --append POSTROUTING --out-interface vboxnet1 -j MASQUERADE
iptables --append FORWARD --in-interface wlp2s0 -j ACCEPT
#VM subnet setup
iptables-save
