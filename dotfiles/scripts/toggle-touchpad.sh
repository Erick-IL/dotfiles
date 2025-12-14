#!/bin/bash

DEVICE="dell0b64:00-06cb:ce81-touchpad"
STATE_FILE="/tmp/touchpad_state"

if [ -f "$STATE_FILE" ]; then
    STATE=$(cat "$STATE_FILE")
else
    STATE="on"
fi

if [ "$STATE" = "on" ]; then
    hyprctl keyword device:$DEVICE:enabled false
    echo "off" > "$STATE_FILE"
    notify-send "Touchpad desativado"
else
    hyprctl keyword device:$DEVICE:enabled true
    echo "on" > "$STATE_FILE"
    notify-send "Touchpad ativado"
fi
