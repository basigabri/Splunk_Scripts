#!/bin/sh

read -p "enter username : "  user
read -p "enter realname : "   real
read -p "enter user's allowed index : "  index
read -p "enter passwd: "  passwd

#Use REST api to add users


curl -k -u admin:changeme https://10.26.204.145:8089/services/authorization/roles \
-d name=$user \
-d imported_roles=power \
-d srchIndexesAllowed=$index


curl -k -u admin:changeme https://10.26.204.146:8089/services/authorization/roles \
-d name=$user \
-d imported_roles=power \
-d srchIndexesAllowed=$index
 curl -k -u admin:changeme https://10.26.204.145:8089/services/authentification/users \
-d name=$user \
-d realname=$real \
-d password=$passwd \
-d defaultApp=search \
-d roles=$user

 curl -k -u admin:changeme https://10.26.204.146:8089/services/authentification/users \
-d name=$user \
-d realname=$real \
-d password=$passwd \
-d defaultApp=search \
-d roles=$user
