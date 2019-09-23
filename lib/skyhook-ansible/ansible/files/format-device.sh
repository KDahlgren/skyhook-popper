#!/bin/bash

set -e

if [ -z "$1" ]
then
  echo "\$1 is empty"
  echo "please pass username in argument \$1"
  echo "forcing program exit..."
  exit 1
else
  echo "\$1 is NOT empty"
  echo "using username '${1}'"
fi
if [ -z "$2" ]
then
  echo "\$2 is empty"
  echo "please pass the disk to format in argument \$2 (eg sda4, sdb, etc.)"
  echo "forcing program exit..."
  exit 1
else
  echo "\$2 is NOT empty"
  echo "using formatting device '${2}'"
fi

sudo mkfs -t ext4 /dev/${2};
sudo mkdir -p /mnt/${2};
sudo mount /dev/${2} /mnt/${2};
sudo chown -R $1:skyhook-PG0 /mnt/${2};
hostname
df -h
sleep 1
echo "done"
