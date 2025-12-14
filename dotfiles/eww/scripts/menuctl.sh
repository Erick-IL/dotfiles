#!/bin/bash

if [[ -z $(eww active-windows | grep 'menuctl') ]]; then
    /usr/local/bin/eww open menuctl && /usr/local/bin/eww update menurev=true
else
    /usr/local/bin/eww update menurev=false
    (sleep 0.2 && /usr/local/bin/eww close menuctl) &
fi
