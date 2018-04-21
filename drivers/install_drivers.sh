#!/bin/sh
set -x
set -e

find . -name install_*_driver.sh -exec /bin/sh -e -x {} \;
