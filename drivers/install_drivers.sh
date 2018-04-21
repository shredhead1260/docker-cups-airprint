#!/bin/sh
set -x
set -e

find . -name 'install_*_driver.sh' | sort |\
while read -r i; do
  sh -x -e $i
  if [ $? -ne 0 ]; then
    exit $?
  fi
done
