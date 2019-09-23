#!/bin/bash

#set -ex

pool_name=$1
obj_name=$2

echo "{ time bin/run-query --num-objs 1 --pool $pool_name --wthreads 1 --qdepth 10 --query flatbuf  --select-preds \";att0,sum,0;\" --table-name \"atable\" --data-schema \"0 7 0 0 ATT0 ;\" > res_${obj_name}_match.txt ; } 2>> res_${obj_name}_time.txt" >> res_${obj_name}_time.txt ;

{ time bin/run-query --num-objs 1 --pool $pool_name --wthreads 1 --qdepth 10 --query flatbuf  --select-preds ";att0,sum,0;" --table-name "atable" --data-schema "0 7 0 0 ATT0 ;" > res_${obj_name}_match.txt ; } 2>> res_${obj_name}_time.txt ;
