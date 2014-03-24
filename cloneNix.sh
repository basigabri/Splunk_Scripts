#!/bin/bash

file=/srv/splunk/etc/apps/tUGO-Unix
pwd=/srv/splunk/etc/apps
nix2=-Unix
if [ $(id -u) -eq 0 ]; then
        read -p "Enter new project-NIX : "  nix

	echo $nix$nix2

cp -rv $file $pwd/$nix$nix2

echo "cding to path '$pwd/$nix$nix2/default/data/ui/views"

sed -i 's/tugo/$nix/g' $pwd/$nix$nix2/default/data/ui/views/*.xml
sed -i 's/tugo/$nix/g' $pwd/$nix$nix2/metadata/local.meta
sed -i 's/tugo/$nix/g' $pwd/$nix$nix2/default/macros.conf
sed -i 's/tugo/$nix/g' $pwd/$nix$nix2/default/savedsearches.conf

else

	echo "Only root should do this fellow..."
        exit 

fi




