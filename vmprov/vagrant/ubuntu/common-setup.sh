#!/bin/bash
sudo timedatectl set-timezone Europe/Kiev
sudo chmod 777 /etc/ssh/sshd_config
sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config > tmp
sudo cat tmp > /etc/ssh/sshd_config
sudo sed 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config > tmp
sudo cat tmp > /etc/ssh/sshd_config
sudo service ssh restart
echo -e "user1!\nuser1!" | sudo passwd root
