#!/bin/bash

if [[ -z $(eww active-windows | grep 'calendar') ]]; then
    /usr/local/bin/eww open calendar && /usr/local/bin/eww update calrev=true
else
    /usr/local/bin/eww update calrev=false
    (sleep 0.2 && /usr/local/bin/eww close calendar) &
fi
