#!/bin/bash

set -ex

pool=$1
objfile=$2
objnum=$3

echo "Loading obj.$objnum into pool $pool..."
objname="obj.${objnum}"
rados -p $pool rm $objname || true
echo "writing $objfile into $pool/$objname"
rados -p $pool put $objname $objfile &
wait
