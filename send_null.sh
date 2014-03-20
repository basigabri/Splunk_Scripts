#!/bin/sh

#####author:b.chatzigavriil
###send all data to black hole /dev/null in order to not expire splunk trial license (500MB)
###additionally you have to delete host entries for services you want to index data on Splunk (props.conf) and restart Splunk


#login with valid session
splunk login -auth admin:telefonica123

#get list of hosts sending data

splunk search '|savedsearch "get all hosts sending data"' | awk '{print $2}' | grep -v 'host' > hosts.txt


tail -n +2 hosts.txt | while read line
do

	echo "
[host::$line]
TRANSFORMS-null= setnull" >> /srv/splunk/etc/system/local/props.conf
 done



