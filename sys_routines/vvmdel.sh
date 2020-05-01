#!/bin/bash
cd /scripts_hvv/vmprov/vagrant/
vagrant destroy
ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.0.201"
ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.0.202"
ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.0.203"
ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.0.204"
ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.0.205"
ssh-keygen -f "/home/hvv/.ssh/known_hosts" -R "192.168.0.201"
ssh-keygen -f "/home/hvv/.ssh/known_hosts" -R "192.168.0.202"
ssh-keygen -f "/home/hvv/.ssh/known_hosts" -R "192.168.0.203"
ssh-keygen -f "/home/hvv/.ssh/known_hosts" -R "192.168.0.204"
ssh-keygen -f "/home/hvv/.ssh/known_hosts" -R "192.168.0.205"
