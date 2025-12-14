#!/bin/bash

if [[ -z $(eww active-windows | grep 'usrctl') ]]; then
    /usr/local/bin/eww open usrctl && /usr/local/bin/eww update ctlrev=true
else
    /usr/local/bin/eww update ctlrev=false
    (sleep 0.2 && /usr/local/bin/eww close usrctl) &
fi
