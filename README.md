# Docker Hosts
Bash script to populate docker container IPs in /etc/hosts

## Summary
The script takes the following steps:
* Check if root access
* Remove all already present entries matching `'/^172\..*\.docker/d'`
* Check which containers are running
* For each running container add an entry into the `/etc/hosts` file using the following format:
    * *container-name* *container-ip*.docker

## Crontab
Add the following line **as root** to the crontab to update the `/etc/hosts` file every 5 minutes
```
# m     h       dom     mon     dow     command
  */5   *       *       *       *       <path-to-the-script>/docker-hosts.sh
```

## Requirements
This script requires `docker 1.12` as minimum.
