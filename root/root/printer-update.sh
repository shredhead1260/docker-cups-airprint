#!/bin/bash
umask 0133
inotifywait -m -e close_write,moved_to,create /etc/cups | 
while read -r directory events filename; do
	if [ "$filename" = "printers.conf" ]; then
		rm -rf /services/AirPrint-*.service
		#if [ -f /services/airprint-generate.py ]; then
		#	cp -fau /services/airprint-generate.py /root/airprint-generate.py
		#fi
		/root/airprint-generate.py -d /services > /services/airprint-generate.log 2>&1
		chmod 644 /services/AirPrint-*.service
		cp /etc/cups/printers.conf /config/printers.conf
	fi
done
