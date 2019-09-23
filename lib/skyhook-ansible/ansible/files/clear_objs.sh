#! bin/bash
# clear_objs.sh

for i in $(rados -p $1 ls); do
  echo $i ;
  rados -p $1 rm $i;
done ;
