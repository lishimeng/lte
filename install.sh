#!/bin/bash

# Stop on the first sign of trouble
#set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

function echo_yellow()
{
    echo -e "\033[1;33m$1\033[0m"
}

function install_udhcpc()
{
    echo_yellow "install udhcp"
    apt-get -y update && apt-get install libqmi-utils udhcpc
}

function uninstall_qmi()
{
    rm -rf /usr/local/qmi
}

function install_qmi()
{
    echo_yellow "install qmi"
    cp -r qmi /usr/local/
    chmod +x /usr/local/qmi/quectel-CM
    chmod +x /usr/local/qmi/modify_apn.sh
    chmod +x /usr/local/qmi/assets/qmi_connect.sh
    
    echo_yellow "link qmi service"
    cp /usr/local/qmi/assets/qmi_connect.service /lib/systemd/system/
    
    echo_yellow "install qmi completed"
    echo_yellow "use modyfi_apn.sh to config lte"
    echo_yellow "use systemctl enable qmi_connect to enable lte"
    echo_yellow "use systemctl start qmi_connect to start lte"
}

install_udhcpc

uninstall_qmi
install_qmi