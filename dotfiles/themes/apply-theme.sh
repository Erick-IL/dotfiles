#!/bin/bash
set -e

# Caminho do symlink "current"
THEME_DIR="$HOME/.config/themes/current"

# Resolve o caminho real do link (tema ativo)
REAL_THEME_DIR=$(readlink -f "$THEME_DIR")
COLORS_FILE="$REAL_THEME_DIR/colors.conf"

# Destinos
EWW_CSS="$HOME/.config/eww/colors.scss"
KITTY_CONF="$HOME/.config/kitty/theme.conf"
HYPR_CONF="$HOME/.config/hypr/colors.conf"

# --- Verificação básica ---
if [ ! -f "$COLORS_FILE" ]; then
    echo "❌ Arquivo de cores não encontrado em: $COLORS_FILE"
    exit 1
fi

# --- Função auxiliar pra ler key=value ---
parse_colors() {
    grep -v '^\s*$' "$COLORS_FILE" | grep -v '^#'
}

# --- EWW ---
echo "/* Auto-generated EWW theme */" > "$EWW_CSS"
while IFS== read -r key value; do
    [[ -z "$key" ]] && continue
    echo "\$${key}: ${value};" >> "$EWW_CSS"
done < <(parse_colors)

# --- Kitty ---
echo "# Auto-generated Kitty theme" > "$KITTY_CONF"
while IFS== read -r key value; do
    [[ -z "$key" ]] && continue
    echo "${key} ${value}" >> "$KITTY_CONF"
done < <(parse_colors)

# --- Hyprland ---
echo "# Auto-generated Hyprland colors" > "$HYPR_CONF"
while IFS== read -r key value; do
    [[ -z "$key" ]] && continue
    echo "\$${key} = ${value}" >> "$HYPR_CONF"
done < <(parse_colors)

# --- Wallpaper (segue o link) ---
if ! pgrep -x "swww-daemon" >/dev/null; then
    swww-daemon &
    sleep 1
fi

if [ -f "$REAL_THEME_DIR/wallpaper.png" ]; then
    swww img "$REAL_THEME_DIR/wallpaper.png"
elif [ -f "$REAL_THEME_DIR/wallpaper.jpg" ]; then
    swww img "$REAL_THEME_DIR/wallpaper.jpg"
fi

# --- Aplica bordas do Hyprland (direto via hyprctl) ---
source "$HYPR_CONF" 2>/dev/null || true

if command -v hyprctl >/dev/null; then
    hyprctl keyword decoration:active_border_color "${accent:-#89b4fa}" >/dev/null 2>&1
    hyprctl keyword decoration:inactive_border_color "${muted:-#585b70}" >/dev/null 2>&1
fi

# --- Reload EWW ---
eww reload 2>/dev/null || true

# --- Notificação ---
if command -v notify-send >/dev/null; then
    notify-send "🎨 Tema aplicado" "EWW, Kitty e Hyprland atualizados com sucesso."
else
    echo "✅ Tema aplicado com sucesso."
fi
