#!/bin/bash

if [ -z "$MY_WAN_IP" ]
then
    export MY_WAN_IP=$(curl --max-time 2 -s ip.me)
fi

echo "$MY_WAN_IP"
