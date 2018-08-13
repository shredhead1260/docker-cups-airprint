FROM ubuntu:latest
ARG MIRROR
ENV MIRROR ${MIRROR:-mirror://mirrors.ubuntu.com/mirrors.txt}
# Replace archive repo with mirrors to avoid hash sum issue
RUN sed -i "s;http://.*.ubuntu.com/ubuntu/;${MIRROR};g" \
/etc/apt/sources.list

# Install the packages we need. Avahi will be included
RUN apt-get update && apt-get install -y \
	hplip \
	cups \
	cups-pdf \
	inotify-tools \
	python-cups \
	python-lxml

# Clean up after installation
RUN rm -rf /var/lib/apt/lists/*

# This will use port 631
EXPOSE 631

# We want a mount for these
VOLUME /config
VOLUME /services

# Add scripts
ADD root /
RUN chmod +x /root/*
CMD ["/root/run_cups.sh"]

# Baked-in config file changes
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
	sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
	echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf

