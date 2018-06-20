#!/bin/bash
function pretty_print {
  echo -e "${GREEN}$1${NC}"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

DIR=$(dirname $(readlink -f $0))
DIR_USER=$(stat -c '%U' $DIR)
VENV_DIR="$DIR/env"
SERVICE_DIR='/etc/systemd/system'
SUDO='sudo'

if [[ $EUID -eq 0 ]]; then
  if [[ $(whoami) -ne $DIR_USER ]]; then
    pretty_print "${RED}This script must not be run as root!$NC"
    pretty_print "Run as $RED$DIR_USER$GREEN instead."
    pretty_print "You'll be prompted when elevated privileges are necessary."
    exit 1
  fi
  SUDO=''
fi

export DEBIAN_FRONTEND=noninteractive

pretty_print "Installing Docker Hosts from $RED$DIR$NC"

pretty_print "Installing dependencies"
$SUDO apt --yes install python3 python3-pip python3-venv

pretty_print "Creating a virtualenv in $RED$VENV_DIR$NC"
python3 -m venv $VENV_DIR

pretty_print "Activating the virtualenv"
source env/bin/activate

pretty_print "Install docker inside virtualenv"
pip install docker
deactivate

pretty_print "Adapt absolute paths in sources"
sed -i -e "s|/home/mathijs/git/docker/docker-hosts|$(pwd)|g" $(grep -Irl /home/mathijs/git/docker/docker-hosts)

pretty_print "Copy service files to $RED$SERVICE_DIR"
$SUDO cp docker-hosts.service $SERVICE_DIR

pretty_print "Install and enable the service"
$SUDO systemctl daemon-reload
$SUDO systemctl start docker-hosts.service
$SUDO systemctl enable docker-hosts.service

pretty_print "Verify if ${RED}docker-hosts.service${GREEN} is running"
systemctl status docker-hosts.service
