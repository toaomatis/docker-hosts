# Docker Hosts
Python service to populate docker container IPs in `/etc/hosts`

# Source code
Clone the repository to a directory of your choice. As long as it is at a non-volatile location.

```sh
git clone https://gitlab.huntfield35.nl/docker/docker-hosts.git
```

There are two ways to install and configure this service:
* Using the `install.sh` script
* Manual

# Installation using the `install.sh` script
Run the `install.sh` script as regular user. You'll be prompted when elevated privileges are necessary.
```sh
cd docker-Hosts
./install.sh
```

# Manual Installation

To run this service, you need a few dependencies.
## Dependencies

### python3 pip
```sh
sudo apt install python3 python3-pip
```

### virtualenv
```sh
pip3 install virtualenv
```

Navigate to the source directory and create a virtual environment
```sh
cd docker-Hosts
python3 -m venv ./env
```

Source the virtual environment and install the python3 docker package
```sh
source env/bin/activate
pip install docker
# exit the virtual environment
deactivate
```

## Configuration
Due to the way python and Linux' services work, we need to manually adapt some hard coded full paths.

This can be done by executing the following shell script from the source root
```sh
sed -i -e "s|/home/mathijs/git/docker/docker-hosts|$(pwd)|g" $(grep -Irl /home/mathijs/git/docker/docker-hosts)
```

Install the service as a super user, start and enable it so it runs every system (re)start.
```sh
sudo su
cp docker-hosts.service /etc/systemd/system
systemctl start docker-hosts.service
systemctl enable docker-hosts.service
```

## Verification
First check if the service is running
```sh
systemctl status docker-hosts.service
```

If there are any Docker containers running, they should be added to `/etc/hosts` file
```sh
cat /etc/hosts
```

There should be a list with the IP addresses of the running Docker containers between two comment lines
```
# Docker hosts start
172.19.0.6 webserver.test
172.19.0.5 php-fpm.test
172.19.0.4 mariadb.test
172.19.0.3 redis.test
172.19.0.2 mongo.test
# Docker hosts end
```

# Success!
After either of the installation methods you should be able to connect to each container via its name and the `.test` TLD.
![Success Kid](http://mrwgifs.com/wp-content/uploads/2013/08/Success-Kid-Meme-Gif.gif)

# Remark
This script requires `docker 1.12` as minimum.
