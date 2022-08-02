#!/bin/bash

echo "qmi connect script"
cd /usr/local/qmi

ping_cnt_failure=0

while true; do

    NET_NAME=`qmicli -d /dev/cdc-wdm0 -w`
    ret=`ps -ef|grep quectel-CM|grep -v grep|wc -l`
    if [ "$ret" = "1" ]; then
        ping -c 1 8.8.8.8
        if [ $? -eq 0 ]; then
            echo "ping 8.8.8.8 normal ok, continue."
            sleep 600
            continue
        else
            let ping_cnt_failure=ping_cnt_failure+1
            echo "ping 8.8.8.8 normal failure, ping_cnt_failure:$ping_cnt_failure."
            if [ $ping_cnt_failure -gt 5 ]; then
                sleep 20
                break
            fi
        fi
        ping -I $NET_NAME -c 1 8.8.8.8
        if [ $? -eq 0 ]; then
            echo "ping 8.8.8.8 via $NET_NAME ok, add default $NET_NAME..."
            route del default
            route add default dev $NET_NAME
            let ping_cnt_failure=0
            continue
        fi
    else
        ip link set $NET_NAME down
        echo 'Y' | sudo tee /sys/class/net/$NET_NAME/qmi/raw_ip
        ./quectel-CM -s #APN &
    fi

    sleep 30
done

echo "exit qmi_connect.sh"
killall -9 quectel-CM
