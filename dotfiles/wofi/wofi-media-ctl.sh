#!/bin/bash

# --- CONFIGURAÇÕES ---
WOFI_CONFIG="-s ${HOME}/.config/wofi/media-ctl.css"
WOFI_FLAGS="--dmenu --allow-images --show dmenu"
# O número de blocos para a barra de progresso
PROGRESS_BLOCKS=15
# Ícones Nerd Font
ICON_PAUSE="󰏤" # Pausa
ICON_PLAY="󰐎"   # Play
ICON_PREV="󰒭"   # Anterior
ICON_NEXT="󰒮"   # Próxima
ICON_STOP="󰛶"   # Stop/Vazio

# --- FUNÇÃO PRINCIPAL ---
generate_wofi_output() {
    # Coleta metadados (garante que playerctl esteja instalado)
    TITLE=$(playerctl metadata title 2>/dev/null)
    ARTIST=$(playerctl metadata artist 2>/dev/null)
    ART_URL=$(playerctl metadata mpris:artUrl 2>/dev/null)
    STATUS=$(playerctl status 2>/dev/null)

    TITLE=${TITLE/&/&amp;}
    ARTIST=${ARTIST/&/&amp;}
    
    # Progresso e Duração (em segundos)
    POS_US=$(playerctl position 2>/dev/null)
    LEN_US=$(playerctl metadata mpris:length 2>/dev/null)
    
    POS_US=${POS_US/.*}
    LEN_US=${LEN_US/.*}
    
    # Verifica se os valores são válidos antes de continuar
    if [[ -z "$LEN_US" || "$LEN_US" -eq 0 ]]; then
        STATUS="Stopped"
        LEN_US=1 # Evita divisão por zero
    else
        # Converte microsegundos para segundos (agora são inteiros válidos)
        POS_S=$((POS_US / 1000000))
        LEN_S=$((LEN_US / 1000000))
    fi

    if [[ "$STATUS" == "Playing" || "$STATUS" == "Paused" ]]; then
        # Calcula a porcentagem de progresso
        PERCENT=$((POS_S * 100 / LEN_S))
        
        # Simula a barra de progresso com blocos (Nerd Font)
        FILLED=$(( (PERCENT * PROGRESS_BLOCKS) / 100 ))
        EMPTY=$((PROGRESS_BLOCKS - FILLED))
        
        BAR=$(printf "█%.0s" $(seq 1 $FILLED))
        BAR+=$(printf "░%.0s" $(seq 1 $EMPTY))
        
        # Formata o tempo (MM:SS)
        TIME_CURRENT=$(printf "%02d:%02d" $((POS_S / 60)) $((POS_S % 60)))
        TIME_TOTAL=$(printf "%02d:%02d" $((LEN_S / 60)) $((LEN_S % 60)))
        
        # Linha de Progresso formatada
        PROGRESS_LINE="$TIME_CURRENT $BAR $TIME_TOTAL"
        
        # Icone Play/Pause
        PLAY_PAUSE_ICON=$([[ "$STATUS" == "Playing" ]] && echo "$ICON_PAUSE" || echo "$ICON_PLAY")

        # Baixar e preparar a imagem para o Wofi (só aceita caminhos locais)
        IMG_PATH="/tmp/wofi_media_cover.png"
        
        if [[ -n "$ART_URL" ]]; then
            # Se for uma URL (HTTP/HTTPS), faz o download
            if [[ "$ART_URL" =~ ^https?:// ]]; then
                curl -s "$ART_URL" -o "$IMG_PATH"
            # Se for um caminho de arquivo local (file://), copia
            elif [[ "$ART_URL" =~ ^file:// ]]; then
                cp "${ART_URL/file:\/\//}" "$IMG_PATH"
            fi
        fi

		echo "img:$IMG_PATH"
        echo "$TITLE - $ARTIST"

        echo "$PROGRESS_LINE"

 		echo "playerctl previous :: $ICON_PREV"
 		        echo "playerctl play-pause :: $PLAY_PAUSE_ICON"
 		        echo "playerctl next :: $ICON_NEXT"
 		        echo "playerctl stop :: $ICON_STOP"

    else
        # Se não houver mídia tocando
        echo "playerctl play :: $ICON_PLAY Sem mídia tocando. Clique para iniciar."
    fi
}

# 4. Executar o Wofi
# O Wofi lê a lista gerada pela função, e o comando escolhido é enviado para o shell
generate_wofi_output | wofi $WOFI_CONFIG $WOFI_FLAGS
