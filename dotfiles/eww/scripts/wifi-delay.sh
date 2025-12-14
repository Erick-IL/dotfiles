#!/bin/bash

/usr/local/bin/eww update wifihov=true
(sleep 0.45 && /usr/local/bin/eww update wifirev="$(/usr/local/bin/eww get wifihov)") &
