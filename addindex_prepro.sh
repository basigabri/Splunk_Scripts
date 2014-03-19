#!/bin/bash
index2=index
role=_role

#script to add new index to peers

if [ $(id -u) -eq 0 ]; then
read -p "Enter new name for index : " index
read -p "enter username : " user
read -p "enter realname : " real
read -p "enter passwd: " passwd


echo $index
egrep "$index" /srv/splunk/etc/apps/search/local/indexes.conf >/dev/null

if [ $? -eq 0 ]; then
echo "$index exists!"
                exit 1

else
splunk add index $index$index2

[ $? -eq 0 ] && echo "Index has been added to SPLUNK!" || echo "Failed to add new index!"


# echo $entry >> /srv/splunk/etc/master-apps/_cluster/local/indexes.conf

fi
else
echo "Only root may add index to the system"
        exit 2
fi

#Use REST api to add users


curl -k -u admin:telefonica123 https://localhost:8089/services/authorization/roles \
-d name=$user$role \
-d imported_roles=power \
-d srchIndexesAllowed=$index$index2 \
-d srchIndexesDefault=$index$index2

 curl -k -u admin:telefonica123 https://localhost:8089/services/authentification/users \
-d name=$user \
-d realname=$real \
-d password=$passwd \
-d defaultApp=search \
-d roles=$user$role

