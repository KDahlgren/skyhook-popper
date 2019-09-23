#!/bin/bash

reprod_dir=$(pwd) ;
ansible_dir="${HOME}/skyhook-ansible/ansible/" ;

# ----------------------------------------- #
# CHECK IF DOCKER IS RUNNING
# ----------------------------------------- #
python - << END
import subprocess
import sys
output = subprocess.check_output( "docker info", shell=True )
if "Client:\n Debug Mode:" in output :
  print "docker found!"
else :
  print "ERROR: dockerd not running. please open docker to run experiments. aborting..."
  sys.exit(1)
END

# ----------------------------------------- #
# SETUP 4OSDs
# ----------------------------------------- #
#cp ${reprod_dir}/geni/hosts.ini_4 ${reprod_dir}/geni/hosts.ini ;
#cp ${reprod_dir}/geni/hosts_4 ${reprod_dir}/geni/hosts ;
#cp ${reprod_dir}/geni/request.py_4 ${reprod_dir}/geni/request.py ;
#cp ${reprod_dir}/ansible/transforms_4osds.yml ${reprod_dir}/ansible/extra-vars.yml ;

cp ${reprod_dir}/geni/request.py_1 ${reprod_dir}/geni/request.py ;
cp ${reprod_dir}/ansible/transforms_1osd.yml ${reprod_dir}/ansible/extra-vars.yml ;

# ----------------------------------------- #
# RUN POPPER -- 4OSDs
# ----------------------------------------- #
popper_start=$(date -u +%s) ;
cmd="popper run" ;
echo "cmd=$cmd"
eval "$cmd" ;
popper_end=$(date -u +%s) ;
popper_dur=$(echo "$popper_end - $popper_start" | bc) ;
echo "Command ran: ${cmd}" ;
echo "popper_start=$popper_start popper_end=$popper_end popper_duration=$popper_dur" ;

# ----------------------------------------- #
# SETUP 8OSDs
# ----------------------------------------- #
#cp ${reprod_dir}/geni/hosts.ini_8 ${reprod_dir}/geni/hosts.ini ;
#cp ${reprod_dir}/geni/hosts_8 ${reprod_dir}/geni/hosts ;
#cp ${reprod_dir}/geni/request.py_8 ${reprod_dir}/geni/request.py ;
#cp ${reprod_dir}/ansible/transforms_8osds.yml ${reprod_dir}/ansible/extra-vars.yml ;

# ----------------------------------------- #
# RUN POPPER -- 8OSDs
# ----------------------------------------- #
#popper_start=$(date -u +%s) ;
#cmd="popper run" ;
#echo "cmd=$cmd"
#eval "$cmd" ;
#popper_end=$(date -u +%s) ;
#popper_dur=$(echo "$popper_end - $popper_start" | bc) ;
#echo "Command ran: ${cmd}" ;
#echo "popper_start=$popper_start popper_end=$popper_end popper_duration=$popper_dur" ;
