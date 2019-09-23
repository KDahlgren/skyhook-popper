#!/bin/bash
ssh-keyscan $2 >> ~/.ssh/known_hosts ;
su - $1 -c "rsync $1@$2:$3/'*'" ;
