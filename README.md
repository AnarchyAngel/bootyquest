###########################
# [B]ooty [Q]uest         #
# By Adam Espitia         #
# aahideaway.blogspot.com #
# Arr, matey,             #
#      where be me booty! #
###########################

Creates two folders: /media/vulnshare and /tmp/loot
Creates one file: bq_log.txt

This script will mount/download content from a remote host and search it for sensitive information."

Usage here:
./bq.sh nfs 192.168.1.1 /share/here/
./bq.sh smb 192.168.1.1 /share/here/
./bq.sh ftp 192.168.1.1
./bq.sh http 192.168.1.1 /dir/path/
./bq.sh local /dir/path/
