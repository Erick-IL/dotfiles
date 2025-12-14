

#!/usr/bin/env bash

# Caminho absoluto para o seu style.css
# MUDE ESTA LINHA se o seu caminho for diferente!
CSS_PATH="/home/erick/.config/wofi/style.css"

# Lista de opções de teste simples
OPTIONS="Opção 1 (teste de cor)\nOpção 2 (teste de seleção)\nOpção 3 (fundo)"

# Texto para o prompt
INFO_TEXT="TESTE DE COR DMENU"

# Comando Wofi para forçar o tema e testar a exibição
# Usamos -W 300 para garantir que a janela abra pequena
CHOSEN=$(echo -e "$OPTIONS" | wofi --dmenu \
    -p "$INFO_TEXT" \
    --allow-images )

# Se algo for selecionado, apenas imprime o resultado no terminal
if [[ ! -z "$CHOSEN" ]]; then
    echo "Você selecionou: $CHOSEN"
fi

exit 0
