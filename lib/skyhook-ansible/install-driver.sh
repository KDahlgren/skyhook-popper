#!/bin/bash
# set  -e

# -------------------------------------------------------------------- #
# SETUP AND INSTALL CEPH
# -------------------------------------------------------------------- #
if [ $# -le 1 ]
then
  echo "Usage:"
  echo "bash install-driver.sh <number-of-osds> <path-to-your-id_rsa> <>"
  echo "forcing program exit..."
  exit 1
else
  echo "using nosds as '${1}'"
  echo "using sshkeypath as '${2}'"
fi

# -------------------- #
# GET INPUTS
# -------------------- #
nosds=$1
sshkeypath=$2
repo_dev_name=$3
osd_dev_name=$4
skyhook_branch=$5
ceph_conf=$6

# -------------------- #
# PRELIMS
# -------------------- #
max_osd=$((nosds-1))

echo "START:"
echo `date`

cd $HOME
# get all the scripts and sample data from public repo.
echo "also assumes your cluster ssh generic privkey is avail at absolute path provided as arg (for node to node ssh)."
sleep 5s

# hardcoded vars for now.
ansible_dir="${HOME}/skyhook-ansible/ansible/"
echo "clear out prev data dirs and scripts."
scripts_dir="${HOME}/pdsw19-reprod/scripts/"
data_dir="${HOME}/pdsw19-reprod/data/"
touch nodes.txt
rm nodes.txt
touch postreqs.sh
rm postreqs.sh
touch cluster_setup_copy_ssh_keys.sh
rm cluster_setup_copy_ssh_keys.sh

# -------------------- #
# CLUSTER SSH
# -------------------- #
# setup common ssh key for all client/osd nodes.
# this should be provided by the user,
# it is the key they use to ssh into their cloudlab profile machines.
echo "setup ssh keys..."
cd $HOME
touch  $HOME/.ssh/id_rsa
cp $HOME/.ssh/id_rsa ~/.ssh/id_rsa.bak
cp $sshkeypath  ~/.ssh/id_rsa
chmod 0600 $HOME/.ssh/id_rsa;

echo "create nodes.txt file for ssh key copy/setup"
cd $HOME
echo "client0" > nodes.txt;
for ((i = 0 ; i < $nosds ; i++)); do
  echo "osd${i}" >> nodes.txt;
done;

echo "Setting up ssh keyless between all machines..."
cp $scripts_dir/cluster_setup_copy_ssh_keys.sh . ;
sh cluster_setup_copy_ssh_keys.sh;

# -------------------- #
# ANSIBLE PREREQS
# -------------------- #
echo "setup ansible prereqs via script, and install other small stuff locally...";
echo | sudo apt-add-repository ppa:ansible/ansible ;
sudo apt-get update ;
sudo apt-get install ansible -y ;
sudo apt-get install tmux -y ;
cd ~ ;
git clone https://github.com/KDahlgren/skyhook-ansible.git ;
cd skyhook-ansible ;
git submodule update --init ;
sudo apt-get install dstat;
yes | sudo apt-get install x11-apps;
sudo apt-get install scite;

# -------------------- #
# WRITE THE ANSIBLE HOSTS FILE
# -------------------- #
echo "specify correct num osds for this cluster in ansible hosts file";
cd $HOME
head -n 4 $ansible_dir/hosts >> $ansible_dir/tmp.yml;
for ((i = 0 ; i < $nosds ; i++)); do
  echo "osd${i}" >> $ansible_dir/tmp.yml;
done;
mv $ansible_dir/tmp.yml $ansible_dir/hosts;
rm -rf $ansible_dir/tmp.yml ;
cp $ansible_dir/hosts $ansible_dir/lib/ceph-deploy-ansible/ansible/hosts;

echo "VERIFY osds all there"
cat $ansible_dir/lib/ceph-deploy-ansible/ansible/hosts;

# -------------------- #
# WRITE THE ANSIBLE VARS FILE
# -------------------- #
echo "write the vars file used for skyhook install based on commandline inputs..."
# note the first echo overwrites existing generated vars file and the rest append:
echo "---" > $ansible_dir/vars/install-driver-generated.yml;
echo "repo_dev_name: ${repo_dev_name}" >> $ansible_dir/vars/install-driver-generated.yml;
echo "osd_dev_name: ${osd_dev_name}" >> $ansible_dir/vars/install-driver-generated.yml;
echo "skyhook_branch: ${skyhook_branch}" >> $ansible_dir/vars/install-driver-generated.yml;
echo "ceph_conf: ${ceph_conf}" >> $ansible_dir/vars/install-driver-generated.yml;

# -------------------- #
# INSTALL SKYHOOK
# -------------------- #
# sanity check:
echo "visually  verify all sda4 mounted at /mnt/sda4.";
cd $HOME
for n in `cat nodes.txt`; do
  echo $n
  ssh $n "df -h | grep sda4;";
done;
sleep 3s;

# INSTALLING SKYHOOK
echo `date`;
echo "run ansible playbook to install skyhook on cluster!";
cd $ansible_dir;
vars_file="${ansible_dir}/vars/install-driver-generated.yml" ;
cmd="time ansible-playbook setup_playbook.yml --extra-vars \"vars_file=${vars_file}\"" ;
echo "running cmd : $cmd" ;
eval $cmd ;
echo `date`;
echo "ansible playbook done.";
sleep 10s;

# -------------------------------------------------------------------- #
# COPY DATA FOR TESTS AND DO ANY ADDITIONAL COMPILES
# -------------------------------------------------------------------- #
cd /mnt/sda4/skyhookdm-ceph/build ;
cp ${HOME}/pdsw19-reprod/data/* . ;
#make -j36 fbwriter run-query run-copyfrom-merge run-client-merge ;

# -------------------------------------------------------------------- #
# WRITE 10MB OBJECT FILES
# -------------------------------------------------------------------- #
#bin/fbwriter --file_name ncols100.10MB.objs.25Krows.csv --schema_file_name ncols100.schema.txt --num_objs 1 --flush_rows 25000 --read_rows 25000 --csv_delim "|" --use_hashing false --rid_start_value 1 --table_name ncols100_10MB --input_oid 0 --obj_type SFT_FLATBUF_FLEX_ROW ;

#bin/fbwriter --file_name lineitem.10MB.objs.75Krows.csv --schema_file_name lineitem.schema.txt --num_objs 1 --flush_rows 75000 --read_rows 75000 --csv_delim "|" --use_hashing false --rid_start_value 1 --table_name lineitem_10MB --input_oid 0 --obj_type SFT_FLATBUF_FLEX_ROW ;

# -------------------------------------------------------------------- #
# WRITE 100MB OBJECT FILES
# -------------------------------------------------------------------- #
#for ((i = 0 ; i < 10 ; i++)); do
#  cat ncols100.10MB.objs.25Krows.csv >> ncols100.100MB.objs.250Krows.csv ;
#done;
#bin/fbwriter --file_name ncols100.100MB.objs.250Krows.csv --schema_file_name ncols100.schema.txt --num_objs 1 --flush_rows 250000 --read_rows 250000 --csv_delim "|" --use_hashing false --rid_start_value 1 --table_name ncols100_100MB --input_oid 0 --obj_type SFT_FLATBUF_FLEX_ROW ;

#for ((i = 0 ; i < 10 ; i++)); do
#  cat lineitem.10MB.objs.75Krows.csv >> lineitem.100MB.objs.750Krows.csv ;
#done;
#bin/fbwriter --file_name lineitem.100MB.objs.750Krows.csv --schema_file_name lineitem.schema.txt --num_objs 1 --flush_rows 750000 --read_rows 750000 --csv_delim "|" --use_hashing false --rid_start_value 1 --table_name lineitem_100MB --input_oid 0 --obj_type SFT_FLATBUF_FLEX_ROW ;
