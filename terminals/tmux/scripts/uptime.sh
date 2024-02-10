#!/usr/local/bin/bash
# uptime | awk '{print $3, $5}' | sed "s/:/ /g" | sed "s/,//g" | awk '{print $1"d", $2"h", $3"m"}'
uptime | awk '{print $3, $5}' | sed "s/:/ /g" | sed "s/,//g" | sed "s/ /:/mod +x "
