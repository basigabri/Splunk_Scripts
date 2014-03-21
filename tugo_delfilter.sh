#!/bin/sh

#deleting rules from props.conf
DELFILTER1=`curl -s -k -u admin:changeme --request DELETE https://$FWDER1:8089/servicesNS/nobody/system/configs/conf-props/host::test 2>&1 >/dev/null`
DELFILTER2=`curl -s -k -u admin:changeme --request DELETE https://$FWDER2:8089/servicesNS/nobody/system/configs/conf-props/host::test 2>&1 >/dev/null`

#Restarting fwders
RESTARTfwder1=`curl -s -k -u admin:changeme https://10.26.204.19:8089/services/server/control/restart -X POST 2>&1 >/dev/null`
RESTARTfwder2=`curl -s -k -u admin:changeme https://10.26.204.20:8089/services/server/control/restart -X POST 2>&1 >/dev/null`

#Declare a funtion to take action

take_action() {
eval ${DELFILTER1} && eval ${DELFILTER2} && eval ${RESTARTfwder1} && sleep 30 && eval ${RESTARTfwder2}
}

take_action

