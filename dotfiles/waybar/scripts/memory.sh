#!/bin/bash

MEM=$(free | awk '/Mem/ {printf "%.0f", ($3/$2) * 100}')
ICON=""

case "$1" in
    --icon)
        echo "$ICON"
        ;;
    --text)
        echo "$MEM%"
        ;;
    *)
        echo "{\"text\": \"$ICON $MEM%\", \"tooltip\": \"Uso de memória: $MEM%\"}"
        ;;
esac
