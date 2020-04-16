#!/bin/bash

cd /scripts_hvv/vmprov/vagrant/
vagrant destroy
ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.0.211"
ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.0.212"
ssh-keygen -f "/root/.ssh/known_hosts" -R "[127.0.0.1]:2222"
ssh-keygen -f "/home/hvv/.ssh/known_hosts" -R "192.168.0.211"
ssh-keygen -f "/home/hvv/.ssh/known_hosts" -R "192.168.0.212"
ssh-keygen -f "/home/hvv/.ssh/known_hosts" -R "[127.0.0.1]:2222"
