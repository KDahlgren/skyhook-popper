#!/bin/bash
pool_name=$1
osd_dev_name=$2
filename=$3
objnum=$4
sudo bash rados-store-glob.sh $pool_name /mnt/$osd_dev_name/$filename $objnum ;
