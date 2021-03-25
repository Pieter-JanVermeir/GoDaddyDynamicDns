#!/bin/bash

NAME="GoDaddy Dynamic DNS updater"
CONF="/etc/godaddydns/config.conf"

mkdir /etc/godaddydns 2> /dev/null
apt install dialog curl -y > /dev/null 2> /dev/null

echo -n "domain=" > $CONF

dialog  --backtitle "$NAME" \
	--title "Configuration:" \
	--inputbox "What is your domain?\neg domain.com" 20 50 2>> $CONF

echo -ne "\nhostname=" >> $CONF

dialog  --backtitle "$NAME" \
        --title "Configuration:" \
        --inputbox "What shoud the A record look like?\neg sub.domain.com or domain.com" 20 50 2>> $CONF

echo -ne "\napikey=" >> $CONF

dialog  --backtitle "$NAME"\
        --title "Configuration:" \
        --inputbox "What is your apikey?" 20 50 2>> $CONF


echo -ne "\ninterval=" >> $CONF

dialog	--backtitle "$NAME"\
	--title "Configuration:"\
	--rangebox "Updatetime min" 20 50 10 1440 30 2>> $CONF

echo -ne "\nnic=" >> $CONF

nics=$(ip link show | grep '<' | cut -d ':' -f2 | tr '\n' ' ')
dialog  --backtitle "$NAME"\
        --title "Configuration:"\
        --inputbox "NIC:\neg: $nics" 20 50 2>> $CONF

cp ./service/godaddydnsupdater.service /etc/systemd/system/godaddydnsupdater.service
chmod +x /etc/systemd/system/godaddydnsupdater.service
systemctl enable godaddydnsupdater
systemctl start godaddydnsupdater

cp ./bin/godaddydynamicdns.sh /bin/godaddydynamicdns
chmod +x /bin/godaddydynamicdns

dialog --backtitle "GoDaddy Dynamic Dns Updater"\
        --msgbox "Configuration complete" 20 50
clear
