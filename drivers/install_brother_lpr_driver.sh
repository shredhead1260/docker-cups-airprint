#!/bin/sh
set -x
set -e

# See http://support.brother.com/g/s/id/linux/en/instruction_prn1a.html
# install libstdc++6 reuiqred by LPR and CPU wrapper
apt-get update && apt-get install -y libstdc++6:i386 || exit 1

find . -type f -name '*cupswrapper*.deb' -printf '%f\n' | sort | \
while read -r cupswrapper ; do
  model=$(echo $cupswrapper|sed 's;cupswrapper.*;;')
  lpr=$(find . -type f -name '$modellpr*.deb' -printf '%f\n')
  if [ -z "{lpr}" ]; then
    echo "Cann't find LPR driver for ${model} cupswrapper driver"
	exit 1
  fi
  echo "Installing cupswrapper LPR drivers for Brother ${model}"
  dpkg -i --force-architecture ${lpr} && \
  dpkg -i --force-architecture ${cupswrapper} || \
  exit 1
done
