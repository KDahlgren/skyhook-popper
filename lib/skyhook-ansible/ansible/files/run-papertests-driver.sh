#!/bin/bash

#set -ex

result_path=$1
pool_name=$2
test_type=$3
obj_name=$4
optype=$5

#echo "bin/run-papertests $result_path $pool_name $test_type $obj_name $optype > res_${obj_name}_match.txt" > res_${obj_name}_time.txt ;
#bin/run-papertests $result_path $pool_name $test_type $obj_name $optype > res_${obj_name}_match.txt ;

echo "{ time bin/run-papertests $result_path $pool_name $test_type $obj_name $optype > res_${obj_name}_match.txt ; } 2>> res_${obj_name}_time.txt" >> res_${obj_name}_time.txt ;

{ time bin/run-papertests $result_path $pool_name $test_type $obj_name $optype > res_${obj_name}_match.txt ; } 2>> res_${obj_name}_time.txt ;
