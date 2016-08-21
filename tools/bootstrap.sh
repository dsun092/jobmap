#!/bin/bash
#
# Stands up installation and configuration of the basic set of
# packages and tooling needed for the CODOT webapp API.  This script
# installs a number of packages and settings.
#
#
set -o nounset
set -o errexit -o errtrace
shopt -s nullglob extglob
export TERM=dumb

# Constants for console logging
readonly Color_switch="\033["
readonly Color_off="${Color_switch}0m"
readonly Color_red="${Color_switch}1;31m"
readonly Color_blue="${Color_switch}0;34m"
readonly Color_green="${Color_switch}1;32m"

declare Django_version="1.8.5"
declare -a Packages=(python-pip python-dev python-lxml libpq-dev postgresql postgresql-contrib nginx postgis libgeos-dev gdal-bin linux-headers-$(uname -r) build-essential dkms)


function Usage
{
    local usage

    usage="Usage: ${0##*/} "
    echo -e >&2 "$usage"

    exit $(( $# ? $1:0 : 1 ))
}

function Exit_Error
{
    local -i status=$1; shift
    trap - EXIT

    (( status != 0 )) || status=1

    echo -e >&2 "Error_Fatal: $@"
    exit $status
}

function Error_Fatal
{
    Exit_Error 1 "$@"
}

function Show_Message
{
    echo -e "********************************************************************************"
    for message in "$@"; do
        echo -e "$message"
    done
    echo -e "********************************************************************************"
}

function Log_Info
{
    echo -e "${Color_blue}[INFO] ${1}${Color_off}"
}

function Log_Error
{
    echo -e "${Color_red}[ERROR] ${1}${Color_off}"
}

function Log_Success
{
    echo -e "${Color_green}[SUCCESS] ${1}${Color_off}"
}

function Install_Os_Packages
{
    Log_Info "Installing Packages: ${Packages[*]}"
    sudo apt-get update
    sudo apt-get --force-yes --yes install ${Packages[*]}
    echo -e
}

function Setup_Nginx
{
    # See: http://smotko.si/nginx-static-file-problem/
    #sudo sed -i 's/sendfile on;/sendfile off;/' /etc/nginx/nginx.conf
    sudo mv /vagrant/tools/jobmap /etc/nginx/sites-available/jobmap
    if [ ! -f /etc/nginx/sites-enabled/jobmap ]; then
        sudo ln -s /etc/nginx/sites-available/jobmap /etc/nginx/sites-enabled
    fi

    sudo chmod 777 /var/log/nginx

    if [ ! -f /var/log/nginx/access.log ]; then
        sudo touch /var/log/nginx/access.log
        sudo chmod 666 /var/log/nginx/access.log
    fi

    if [ ! -f /var/log/nginx/error.log ]; then
        sudo touch /var/log/nginx/error.log
        sudo chmod 666 /var/log/nginx/error.log
    fi

    if [ ! -d /etc/nginx/ssl ]; then
        sudo mkdir /etc/nginx/ssl
        sudo cp /vagrant/tools/server.key /etc/nginx/ssl/server.key
        sudo cp /vagrant/tools/server.crt /etc/nginx/ssl/server.crt
    fi

    Log_Info "Starting nginx"
    sudo service nginx restart
    echo -e
}


function Install_Python_Packages
{
    Log_Info "Installing python web scrapping packages"
    sudo pip install request bs4 pyramid gunicorn
}

function Pyramid_Setup
{

}



Install_Os_Packages
Install_Python_Packages