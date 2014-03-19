#!/bin/bash

file=/root/scripts/users.txt
index2=index
role=_role
passwd=splunk@

cat $file | while read line
do

if [ $(id -u) -eq 0 ]; then
	echo $line
	egrep "$line" /srv/splunk/etc/master-apps/_cluster/local/indexes.conf >/dev/null

	if [ $? -eq 0 ]; then
                echo "$line exists!"
                exit 1

	else


	echo "
[$line$index2]
homePath   = $SPLUNK_HOME/var/lib/splunk/$line/db
coldPath   = $SPLUNK_HOME/var/lib/splunk/$line/colddb
thawedPath = $SPLUNK_HOME/var/lib/splunk/$line/thaweddb
repFactor = auto
frozenTimePeriodInSecs = 2592000" >> /srv/splunk/etc/master-apps/_cluster/local/indexes.conf

	[ $? -eq 0 ] && echo "Index has been added to SPLUNK!" || echo "Failed to add new index!"

	fi
else

	echo "Only root may add index to the system"
        exit 2
	fi

#Use REST api to add users


curl -k -u admin:splunk@telefonica123 https://10.26.204.145:8089/services/authorization/roles \
-d name=$line$role \
-d imported_roles=power \
-d srchIndexesDefault=$line$index2 \
-d srchIndexesAllowed=$line$index2

curl -k -u admin:splunk@telefonica123 https://10.26.204.146:8089/services/authorization/roles \
-d name=$line$role \
-d imported_roles=power \
-d srchIndexesDefault=$line$index2 \
-d srchIndexesAllowed=$line$index2

 curl -k -u admin:splunk@telefonica123 https://10.26.204.145:8089/services/authentification/users \
-d name=$line \
-d realname=$line \
-d password=$passwd$line \
-d defaultApp=search \
-d roles=$line$role

curl -k -u admin:splunk@telefonica123 https://10.26.204.146:8089/services/authentification/users \
-d name=$line \
-d realname=$line \
-d password=$passwd$line \
-d defaultApp=search \
-d roles=$line$role



done
