#!/bin/bash
# set  -e

# -------------------------------------------------------------------- #
# SETUP AND INSTALL CEPH
# -------------------------------------------------------------------- #
nosds=$1
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

echo "create nodes.txt file for ssh key copy/setup"
cd $HOME
echo "client0" > nodes.txt;
for ((i = 0 ; i < $nosds ; i++)); do
  echo "osd${i}" >> nodes.txt;
done;

echo "copy scripts to all nodes"
cd $HOME
for n in  `cat nodes.txt`; do
  echo "copy scripts dir to node ${n}";
  scp -r ${scripts_dir}/*  ${n}:~/ ;
done;

echo "setup ansible prereqs via script, and install other small stuff locally...";
bash postreqs.sh;

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

echo "update the max_osd here /vars/extra_vars.yml  as well."
head -n 4 $ansible_dir/lib/ceph-deploy-ansible/ansible/vars/extra_vars.yml >>   $ansible_dir/lib/ceph-deploy-ansible/ansible/vars/tmp.yml;
echo "num_osds: ${nosds}" >>$ansible_dir/lib/ceph-deploy-ansible/ansible/vars/tmp.yml;
mv $ansible_dir/lib/ceph-deploy-ansible/ansible/vars/tmp.yml $ansible_dir/lib/ceph-deploy-ansible/ansible/vars/extra_vars.yml;
rm -rf $ansible_dir/lib/ceph-deploy-ansible/ansible/vars/tmp.yml;

echo "visually  verify all sda4 mounted at /mnt/sda4.";
cd $HOME
for n in `cat nodes.txt`; do
  echo $n
  ssh $n "df -h | grep sda4;";
done;
sleep 3s;

# INSTALLING VANILLA CEPH LUMINOUS on all nodes client+osds and cls_tabular lib
echo `date`;
echo "run ansible playbook to install vanilla ceph luminous on cluster!";
cd $ansible_dir;
time ansible-playbook transforms_setup_playbook.yml ;
echo `date`;
echo "ansible playbook done.";
sleep 10s;

# -------------------------------------------------------------------- #
# COMPILE BINARIES FOR TRANSFORM TESTS
# -------------------------------------------------------------------- #
cd /mnt/sda4/skyhookdm-ceph/build ;
cp ${HOME}/pdsw19-reprod/data/* . ;
make -j36 fbwriter run-query run-copyfrom-merge run-client-merge ;

# -------------------------------------------------------------------- #
# WRITE 10MB OBJECT FILES
# -------------------------------------------------------------------- #
bin/fbwriter --file_name ncols100.10MB.objs.25Krows.csv --schema_file_name ncols100.schema.txt --num_objs 1 --flush_rows 25000 --read_rows 25000 --csv_delim "|" --use_hashing false --rid_start_value 1 --table_name ncols100_10MB --input_oid 0 --obj_type SFT_FLATBUF_FLEX_ROW ;

bin/fbwriter --file_name lineitem.10MB.objs.75Krows.csv --schema_file_name lineitem.schema.txt --num_objs 1 --flush_rows 75000 --read_rows 75000 --csv_delim "|" --use_hashing false --rid_start_value 1 --table_name lineitem_10MB --input_oid 0 --obj_type SFT_FLATBUF_FLEX_ROW ;

# -------------------------------------------------------------------- #
# WRITE 100MB OBJECT FILES
# -------------------------------------------------------------------- #
for ((i = 0 ; i < 10 ; i++)); do
  cat ncols100.10MB.objs.25Krows.csv >> ncols100.100MB.objs.250Krows.csv ;
done;
bin/fbwriter --file_name ncols100.100MB.objs.250Krows.csv --schema_file_name ncols100.schema.txt --num_objs 1 --flush_rows 250000 --read_rows 250000 --csv_delim "|" --use_hashing false --rid_start_value 1 --table_name ncols100_100MB --input_oid 0 --obj_type SFT_FLATBUF_FLEX_ROW ;

for ((i = 0 ; i < 10 ; i++)); do
  cat lineitem.10MB.objs.75Krows.csv >> lineitem.100MB.objs.750Krows.csv ;
done;
bin/fbwriter --file_name lineitem.100MB.objs.750Krows.csv --schema_file_name lineitem.schema.txt --num_objs 1 --flush_rows 750000 --read_rows 750000 --csv_delim "|" --use_hashing false --rid_start_value 1 --table_name lineitem_100MB --input_oid 0 --obj_type SFT_FLATBUF_FLEX_ROW ;
