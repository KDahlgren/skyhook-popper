#!/bin/bash -x

#cp /proj/skyhook-PG0/keys/ceph_key ~/.ssh/id_rsa ;
#chmod 0600 ~/.ssh/id_rsa ;

if [[ "$HOSTNAME" == "client0"* ]]; then
  echo | sudo apt-add-repository ppa:ansible/ansible ;
  sudo apt-get update ;
  sudo apt-get install ansible -y ; 
  sudo apt-get install tmux -y ; 
  cd ~ ;
  git clone https://github.com/KDahlgren/skyhook-ansible.git ;
  cd skyhook-ansible ;
  git checkout pdsw19 ;
  git submodule update --init ;
  sudo apt-get install dstat;
  yes | sudo apt-get install x11-apps;
  sudo apt-get install scite;
fi


