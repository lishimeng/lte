#!/bin/bash

set -e

if [ $UID != 0 ]; then
    echo "Operation not permitted. Forgot sudo?"
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "The correct command format is:" 
    echo "      sudo $0 \"your_apn_name\"."
    exit 1
fi

cp /usr/local/qmi/assets/qmi_connect.sh /usr/local/qmi/qmi_connect.sh
sed -i "s/#APN/$1/" /usr/local/qmi/qmi_connect.sh
