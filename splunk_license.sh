#!/bin/bash
#
#
# Author:  Basilis Chatzigavriil <e.support1@tid.es>
#
# Splunk to Nagios is Awesome.
# This script can be triggered from a Scheduled Saved Search in Splunk to send alerts to Nagios.
# 
# Pre-requisites:
# mod_gearman and gearmand must be installed on your *nix Splunk server
# 
# Note: must be located in $SPLUNK_HOME/etc/apps/SplunkForNagios/bin/scripts
# Change the following variables so that they are relevant to your environment:
#      * SPLUNKSERVER=splunk01 (ie. hostname of the splunk server)
#      * NAGIOSHOST=hostname or ip of your nagios/icinga
#      * SENDGEARMAN_BIN, GEARMAN_PORT :: Adapt these to your needs
#      * LIMITc = Critical limit of data in GB
#      * LIMITw = Warning  limit of data in GB
#      * SEARCH extract the saved search name out of splunk
#      * DATA makes a curl request to fetch the data flow result
#     

SPLUNKSERVER=ESJC-DSMM-VP05P
WWW=10.26.204.183
SENDGEARMAN_BIN=/usr/bin
NAGIOS_HOST=10.26.204.185
GEARMAN_PORT=4730
SERVICE=`echo $5|awk -F'[' '{print $2}'|awk -F']' '{print $1}'|sed 's/\- //g'|cut -f2- -d " "`
HOST=VIP-splunkmaster
EVENTS=$1
SEARCH=`echo "'$8'"|cut -d/ -f8`
DATA=`curl -s -k -u admin:changeme  https://localhost:8089/servicesNS/admin/search/search/jobs/$SEARCH/results  --get -d output_mode=csv -d count=2  | cut -d, -f8 | grep -v GB | sed -e 's/"//g'`
DATA=`echo $DATA | sed -e 's/ /\+/g' | bc`
LIMITc="32"
LIMITw="25"
URL=`echo $6|sed "s/$SPLUNKSERVER/$WWW/"`



nagios_notify () {
${SENDGEARMAN_BIN}/send_gearman --server=${NAGIOS_HOST}:${GEARMAN_PORT} --encryption=yes --key=clave_compartida_gearman11 --host=${HOST} --service="${SERVICE}" --result_queue=check_results --returncode=${CODE} --message="${MSG}" > /dev/null 2>/dev/null
}

 
answerc=`echo "${DATA} > ${LIMITc}" | bc -l`
answerw=`echo "${DATA} > ${LIMITw}" | bc -l`

#echo 'tst ' $DATA $SERVICE $answerc >>  "$SPLUNK_HOME/bin/scripts/echo_output.txt"
if [ $answerc -eq 1 ]
then
        #echo "'CONDITIONAL_CODE=2'" >> "$SPLUNK_HOME/bin/scripts/echo_output.txt" 
	CODE="2"
	MSG="License Usage: $DATA gb;  INFORMATION: 'License critical, take action !' ; URL: $URL"
        nagios_notify 


elif [ $answerw -eq 1 ]
then

        #echo "'CONDITIONAL_CODE=1'" >> "$SPLUNK_HOME/bin/scripts/echo_output.txt"
	CODE="1"

        MSG="License Usage: $DATA gb;  INFORMATION: 'Please take care of your license!' ; URL: $URL"


	nagios_notify
else 
	#echo "'CONDITIONAL_CODE=0'" >> "$SPLUNK_HOME/bin/scripts/echo_output.txt"

	CODE="0"

	MSG="License Usage: $DATA gb;  INFORMATION: 'License usage ok' ; URL: $URL"

	nagios_notify 


fi
