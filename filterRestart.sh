#!/bin/bash

##author b.chatzigavriil

##script to filter data overdose and stop license violation
##SAVEDSEARCH=`curl -s -k -u admin:splunk@telefonica123 https://localhost:8089/servicesNS/admin/sos/saved/searches/tugo_daily_license/dispatch -d "trigger_action=1" | grep sid | sed -e 's/<[^>]*>//g'`
#DATA=`curl -s -k -u admin:splunk@telefonica123  https://localhost:8089/servicesNS/admin/sos/search/jobs/$SAVEDSEARCH/results --get -d output_mode=csv | grep -v GB| cut -d, -f2| sed -e 's/"//g'i`
DATA=`curl -s -k -u admin:splunk@telefonica123 https://localhost:8089/servicesNS/admin/sos/search/jobs/admin__admin__sos__RMD522807ebd81050dec_at_1395343702_10097/results --get -d output_mode=csv | grep -v GB| cut -d, -f2| sed -e 's/"//g'`

#echo $SAVEDSEARCH
#echo $DATA 
#exit

FWDER1="10.26.204.19"
FWDER2="10.26.204.20"


##adding filters into props.conf
#FILTER=`echo "[host::madjcnl*]\nTRANSFORMS-null= null_log_transform" >> /opt/splunk/etc/system/local/props.conf`

FILTER1=`curl -s -k -u admin:splunk@telefonica123 https://$FWDER1:8089/servicesNS/nobody/system/configs/conf-props -d name=host::test -d TRANSFORMS-log=null_log_transform`

FILTER2=`curl -s -k -u admin:splunk@telefonica123 https://$FWDER2:8089/servicesNS/nobody/system/configs/conf-props -d name=host::test -d TRANSFORMS-log=null_log_transform`


#deleting rules from props.conf
DELFILTER1=`curl -s -k -u admin:splunk@telefonica123 --request DELETE https://$FWDER1:8089/servicesNS/nobody/system/configs/conf-props/host::test`
DELFILTER2=`curl -s -k -u admin:splunk@telefonica123 --request DELETE https://$FWDER2:8089/servicesNS/nobody/system/configs/conf-props/host::test`

RESTARTfwder1=`curl -s -k -u admin:splunk@telefonica123 https://$FWDER1:8089/services/server/control/restart -X POST`
RESTARTfwder2=`curl -s -k -u admin:splunk@telefonica123 https://$FWDER2:8089/services/server/control/restart -X POST`

DATA=`echo $DATA | bc`
LIMITtugo="10"

dataflow=`echo "${DATA} > ${LIMITtugo}" | bc -l`

#echo $DATA 
#echo $dataflow 

#exit
##Declare a funtion to take action

take_action() {
eval $FILTER1 && eval $FILTER2 && eval $RESTARTfwder1 && eval $RESTARTfwder2
}


if [ $dataflow -eq 1 ]

then 

take_action

else

exit

fi
