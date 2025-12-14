#!/bin/bash

/usr/local/bin/eww update keyhov=true
(sleep 0.45 && /usr/local/bin/eww update keyrev="$(/usr/local/bin/eww get keyhov)") &
