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
declare -a Packages=(python-pip python-dev libpq-dev postgresql postgresql-contrib nginx postgis libgeos-dev gdal-bin linux-headers-$(uname -r) build-essential dkms)


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
    sudo apt-get --force-yes --yes install ${Packages[*]}
    echo -e
}

function Install_Python_Packages
{
    Log_Info "Installing python web scrapping packages"
    sudo pip install request lxml bs4
}

Install_Os_Packages