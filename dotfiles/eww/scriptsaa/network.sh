#!/bin/bash

# Pega interface Wi-Fi ativa
WLAN=$(iwctl station list | grep -oP 'wlan\d+' | head -n1)

# Pega SSID atual (nome da rede)
SSID=$(iwctl station "$WLAN" show 2>/dev/null | grep "Connected network" | sed 's/.*Connected network *//' | xargs)

# Pega interface ethernet ativa
ETH=$(ip link | grep -E "state UP" | grep -oE "enp[0-9a-z]+" | head -n1)

if [[ -n "$ETH" ]]; then
    ICON="󰈀"
    NAME="Ethernet"
elif [[ -n "$SSID" ]]; then
    # Pega o RSSI (intensidade do sinal em dBm)
    RSSI=$(iwctl station "$WLAN" show | grep "RSSI" | awk '{print $2}' | tr -d '-' | head -n1)

    # Converte RSSI (~-30 = ótimo, ~-90 = péssimo) para "porcentagem"
    if [[ -n "$RSSI" ]]; then
        SIGNAL=$((100 - (RSSI * 100 / 70))) # escala aproximada
        (( SIGNAL < 0 )) && SIGNAL=0
        (( SIGNAL > 100 )) && SIGNAL=100
    else
        SIGNAL=0
    fi

    # Define ícone conforme intensidade
    if (( SIGNAL >= 80 )); then
        ICON="󰤨"
    elif (( SIGNAL >= 60 )); then
        ICON="󰤥"
    elif (( SIGNAL >= 40 )); then
        ICON="󰤢"
    elif (( SIGNAL >= 20 )); then
        ICON="󰤟"
    else
        ICON="󰤯"
    fi

    NAME="$SSID"
else
    ICON="󰖪"
    NAME="Offline"
fi

# Saída JSON pro Waybar
echo "{\"text\": \"$ICON\", \"class\": \"network\", \"tooltip\": false, \"data-essid\": \"$NAME\"}"
