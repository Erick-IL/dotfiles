#!/bin/bash

# Encontra a interface Wi-Fi ativa
WLAN=$(iwctl station list | grep -oP 'wlan\d+' | head -n1)

[[ -z "$WLAN" ]] && { echo "[]"; exit 0; }

# Força um scan antes de listar
iwctl station "$WLAN" scan >/dev/null 2>&1
sleep 1

# Pega o SSID atual (rede conectada)
CURRENT_SSID=$(iwctl station "$WLAN" show 2>/dev/null | grep "Connected network" | awk '{$1=$2=""; print $0}' | xargs)

declare -A SEEN
wifi_list=()

# Lista as redes
iwctl station "$WLAN" get-networks 2>/dev/null | tail -n +5 | while read -r line; do
    ssid=$(echo "$line" | awk '{print $2}')
    signal=$(echo "$line" | awk '{print $3}')
    security=$(echo "$line" | awk '{print $NF}')

    [[ -z "$ssid" || "$ssid" == "--" ]] && continue
    [[ -n "${SEEN[$ssid]}" ]] && continue
    SEEN["$ssid"]=1

    in_use=false
    [[ "$ssid" == "$CURRENT_SSID" ]] && in_use=true

    wifi_json=$(jq -nc \
        --arg ssid "$ssid" \
        --argjson in_use "$in_use" \
        --arg signal "${signal:-0}" \
        --arg security "$security" \
        '{
          ssid: $ssid,
          in_use: $in_use,
          signal: ($signal | tonumber? // 0),
          security: $security
        }')

    wifi_list+=("$wifi_json")
done

# Gera o JSON final
if [[ ${#wifi_list[@]} -eq 0 ]]; then
    echo "[]"
else
    jq -nc --argjson arr "$(printf '[%s]' "$(IFS=,; echo "${wifi_list[*]}")")" '$arr'

fi
