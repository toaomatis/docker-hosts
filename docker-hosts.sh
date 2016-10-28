#!/bin/bash

hosts_file="/etc/hosts"

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
    # Local hosts file just for testing
    # Comment out the exit 1 above
    hosts_file="hosts"
fi

# Remove all lines starting with an Docker IP Address (typically 172.* range)
sed -i '/^172\./d' $hosts_file

for container_name in $(docker ps --format "{{.Names}}");
do
    container_ip=$(docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" $container_name)
    echo $container_ip $container_name".docker" >> $hosts_file
done
