Extract sid from saved search

###
curl -k -u admin:changeme  https://localhost:8089/servicesNS/admin/sos/saved/searches/tugo_daily_license_usage/dispatch -d "trigger_action=1"

##get results

curl -k -u admin:changeme  https://localhost:8089/servicesNS/admin/sos/search/jobs/admin__admin__sos__RMD54c768f2824697161_at_1395318767_8814/results --get -d output_mode=csv

## get real Num

curl -s -k -u admin:changeme  https://localhost:8089/servicesNS/admin/sos/search/jobs/admin__admin__sos__RMD54c768f2824697161_at_1395318767_8814/results --get -d output_mode=csv | grep -v GB| cut -d, -f2| sed -e 's/"//g'





