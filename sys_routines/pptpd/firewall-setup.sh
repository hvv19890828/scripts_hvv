#!/bin/bash

#Enable port forwarding by editing the sysctl.conf file. I assume “net.ipv4.ip_forward” is commented in the /etc/sysctl.conf file:
#nano /etc/sysctl.conf
#Add or find and comment out the following line
#net.ipv4.ip_forward=1
#Save, close the file and run the following command to make the changes take effect.
#sysctl -p

sysctl -p
iptables -I INPUT -p tcp --dport 1723 -m state --state NEW -j ACCEPT
iptables -I INPUT -p gre -j ACCEPT
iptables -t nat -I POSTROUTING -o enx000ec79ecb52 -j MASQUERADE
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -s 192.168.127.0/24 -j TCPMSS  --clamp-mss-to-pmtu
iptables-save
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables-save
iptables --table nat --append POSTROUTING --out-interface vboxnet1 -j MASQUERADE
iptables --append FORWARD --in-interface wlp2s0  -j ACCEPT
iptables-save
