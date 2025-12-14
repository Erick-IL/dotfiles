#!/bin/bash

TEMP=$(sensors 2>/dev/null | grep "Package id 0:" | awk '{print $4}' | sed 's/[^0-9.]*//g')
ICON=""

case "$1" in
    --icon)
        echo "$ICON"
        ;;
    --text)
        echo "$TEMP"
        ;;
    *)
        echo "{\"text\": \"$ICON $TEMP\", \"tooltip\": \"Temperatura da CPU: $TEMP\"}"
        ;;
esac
