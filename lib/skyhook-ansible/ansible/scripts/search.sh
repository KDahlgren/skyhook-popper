#!/bin/bash

set -e

if [ -z "$1" ]
then
  echo "\$1 is empty"
  echo "please pass a string to search for in \$1"
  echo "forcing program exit..."
  exit 1
else
  echo "\$1 is NOT empty"
  echo "using search string '${1}'"
fi

for f in *.deb; do
  echo "checking in $f:" ;
  if dpkg -c $f | grep $1 ; then
    continue
  else
    continue
  fi
done
