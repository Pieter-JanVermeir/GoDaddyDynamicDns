#!/bin/bash

DOMAIN=$( grep "domain=" /etc/godaddydns/config.conf | cut -d '=' -f2 )
HOSTNAME=$( grep "hostname=" /etc/godaddydns/config.conf | cut -d '=' -f2 )
APIKEY=$( grep "apikey=" /etc/godaddydns/config.conf | cut -d '=' -f2 )
INTERVAL=$( grep "interval=" /etc/godaddydns/config.conf | cut -d '=' -f2 )
NIC=$( grep "nic=" /etc/godaddydns/config.conf | cut -d '=' -f2 )

while [ true ]
do
	myip=$(ip a | grep inet | grep -w "$NIC" | awk {'print $2'} | tr '/' ' ' | awk {'print $1'})
	dnsdata=`curl -s -X GET -H "Authorization: sso-key ${APIKEY}" "https://api.godaddy.com/v1/domains/${DOMAIN}/records/A/${HOSTNAME}"`
	gdip=`echo $dnsdata | cut -d ',' -f 1 | tr -d '"' | cut -d ":" -f 2`
	echo $gdip
	if [ "$gdip" != "$myip" -a "$myip" != "" ]; then
		curl -s -X PUT "https://api.godaddy.com/v1/domains/${DOMAIN}/records/A/${HOSTNAME}" -H "Authorization: sso-key ${APIKEY}" -H "Content-Type: application/json" -d "[{\"data\": \"${myip}\"}]"
	fi
	sleep $(( INTERVAL*60 ))
done
