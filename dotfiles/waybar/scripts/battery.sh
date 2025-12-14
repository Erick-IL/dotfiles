#!/bin/bash

BATTERY_PATH="/sys/class/power_supply/BAT0"
ICONS=("" "" "" "" "")

STATUS=$(cat "$BATTERY_PATH/status")
CAPACITY=$(cat "$BATTERY_PATH/capacity")

# Define ícone
if [[ "$STATUS" == "Charging" ]]; then
    # Anima o ícone baseado no tempo
    SECONDS=$(date +%s)
    FRAME=$((SECONDS % ${#ICONS[@]}))
    ICON="${ICONS[$FRAME]}"
else
    if [[ $CAPACITY -ge 90 ]]; then ICON="";
    elif [[ $CAPACITY -ge 70 ]]; then ICON="";
    elif [[ $CAPACITY -ge 50 ]]; then ICON="";
    elif [[ $CAPACITY -ge 30 ]]; then ICON="";
    else ICON=""; fi
fi

# Saída para o Waybar
case "$1" in
    --icon)
        echo "$ICON"
        ;;
    --text)
        echo "$CAPACITY%"
        ;;
    *)
        echo "{\"text\": \"$ICON $CAPACITY%\", \"tooltip\": \"Status: $STATUS\"}"
        ;;
esac
