#!/bin/bash

# CPU usada em %
CPU=$(mpstat 1 1 | tail -1 | awk '{print 100 - $NF}')
ICON=""

case "$1" in
    --icon)
        echo "$ICON"
        ;;
    --text)
        echo "$CPU%"
        ;;
    *)
        echo "{\"text\": \"$ICON $CPU%\", \"tooltip\": \"Uso da CPU: $CPU%\"}"
        ;;
esac
