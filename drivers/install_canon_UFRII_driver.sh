#!/bin/sh

# Canon Linux UFRII driver file download Linux 64 driver from Canon
# CA: http://www.canon.ca/en/Contact-Support/Consumer/Downloads
# US: https://www.usa.canon.com/internet/portal/us/home/support

# try locating the downloaed driver
PKG=$(find . -maxdepth 1 -type f -name 'linux-UFRII-drv-v*-*.tar.gz' -printf '%f\n' -quit | cut -d. -f1)

# no download driver file found
if [ -z "${PKG}" ]; then
  # look for extracted driver file
  PKG=$(find . -maxdepth 1 -type d -name 'linux-UFRII-drv-v*-*' -printf '%f\n' -quit)
fi

# nothing found
if [ -z "${PKG}" ]; then
  echo "No Canon UFRII driver found"
  exit 0
fi

# if not already unpackaged
if [ ! -d ${PKG} ]; then
  tar zxf ${PKG}.tar.gz
fi

# install it
cd ${PKG} && echo y | ./install.sh && cd ..
