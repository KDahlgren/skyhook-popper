#!/bin/bash
echo "client0" >> nodes.txt
CNT=$1
for ((i=0;i<=$CNT-1;i++)); do
   echo "osd$i" >> nodes.txt
done
