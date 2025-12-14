#!/bin/bash

if [[ -z $(eww active-windows | grep 'wifictl') ]]; then
    /usr/local/bin/eww open wifictl && /usr/local/bin/eww update wifictlrev=true
else
    /usr/local/bin/eww update wifictlrev=false && /usr/local/bin/eww update wificonfigrev=false
    (sleep 0.2 && /usr/local/bin/eww close wifictl) &
fi
