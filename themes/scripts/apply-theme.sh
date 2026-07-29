#!/usr/bin/env bash

THEME_NAME="$1"

if [ -z "$THEME_NAME" ]; then
    echo "Errore: Nessun tema specificato!"
    notify-send -u critical -i dialog-error "Tema non specificato" "Specifica un tema valido."
    exit 1
fi

DOTFILES="$HOME/.dotfiles"
THEMES_DIR="$DOTFILES/themes"
PALETTE_DIR="$THEMES_DIR/palette"
TEMPLATES_DIR="$THEMES_DIR/templates"
CURRENT_SYMLINK="$PALETTE_DIR/current"
TARGET_THEME="$PALETTE_DIR/$THEME_NAME"
JSON_FILE="$TARGET_THEME/colors.json"
STATE_FILE="$PALETTE_DIR/.current_theme"

# 1. Controllo se il tema è già attivo
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "$THEME_NAME" ]; then
    echo "Il tema '$THEME_NAME' è già attivo. Nessuna modifica applicata."
    exit 0
fi

# 2. Crea le cartelle se non esistono
mkdir -p "$TARGET_THEME"
mkdir -p "$TARGET_THEME/wallpapers"

# 3. Se manca il colors.json, ne genera uno standard di fallback
if [ ! -f "$JSON_FILE" ]; then
    echo "colors.json non trovato in $THEME_NAME. Ne creo uno standard..."
    cat <<'EOF' >"$JSON_FILE"
{
  "name": "gruvbox",
  "nvim_colorscheme": "gruvbox",
  "colors": {
    "bg": "#282828",
    "bg_dim": "#1d2021",
    "bg0": "#3c3836",
    "bg1": "#504945",
    "bg2": "#665c54",
    "fg": "#ebdbb2",
    "fg_dim": "#a89984",
    "primary": "#d79921",
    "secondary": "#fabd2f",
    "tertiary": "#fe8019",
    "accent": "#b8bb26",
    "purple": "#d3869b",
    "blue": "#83a598",
    "cyan": "#8ec07c",
    "red": "#fb4934",
    "inactive": "#504945"
  }
}
EOF
fi

# 4. Aggiorna il symlink 'current'
rm -rf "$CURRENT_SYMLINK"
ln -sfn "$TARGET_THEME" "$CURRENT_SYMLINK"

# 5. Funzione per estrarre valori dal JSON
get_json_val() {
    local key="$1"
    grep -oE "\"$key\"[[:space:]]*:[[:space:]]*\"[^\"]+\"" "$JSON_FILE" | head -n 1 | cut -d'"' -f4
}

NVIM_CS=$(get_json_val "nvim_colorscheme")
[ -z "$NVIM_CS" ] && NVIM_CS="$THEME_NAME"

DISPLAY_NAME=$(get_json_val "name")
[ -z "$DISPLAY_NAME" ] && DISPLAY_NAME="$THEME_NAME"

# 6. Compilazione atomica dei template
for tmpl in "$TEMPLATES_DIR"/*; do
    [ -f "$tmpl" ] || continue

    filename=$(basename "$tmpl")
    output_path="$TARGET_THEME/$filename"
    temp_output="${output_path}.tmp"

    cp "$tmpl" "$temp_output"
    sed -i "s|{{nvim_colorscheme}}|$NVIM_CS|g" "$temp_output"

    while IFS= read -r line; do
        if [[ "$line" =~ \"([a-zA-Z0-9_]+)\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
            key="${BASH_REMATCH[1]}"
            val="${BASH_REMATCH[2]}"
            clean_val="${val#\#}"

            sed -i "s|{{$key}}|$val|g" "$temp_output"
            sed -i "s|{{${key}_clean}}|$clean_val|g" "$temp_output"
        fi
    done <"$JSON_FILE"

    mv "$temp_output" "$output_path"
done

# 7. Ricarica i servizi (Hyprland, Kitty, Mako e Neovim)
hyprctl reload
pkill -USR1 kitty
makoctl reload || (
    pkill mako
    mako &
)

# Aggiorna il tema al volo su tutte le istanze di Neovim (LazyVim) aperte
# Cerca i socket attivi di Neovim e invia il comando di cambio colorscheme
if command -v nvim &>/dev/null; then
    for server in $(find "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" -maxdepth 1 -name "nvim.*" -type s 2>/dev/null); do
        # Usa <C-\><C-n> per uscire da qualsiasi modalità (insert/terminal) e lanciare il comando
        nvim --server "$server" --remote-send "<C-\><C-n>:colorscheme $NVIM_CS<CR>" &>/dev/null &
    done
fi

# 8. Gestione Sfondi con transizione ad onda/cerchio
TARGET_WALL_DIR="$TARGET_THEME/wallpapers"
GENERAL_DIR="$DOTFILES/general-wallpapers"

if [ -d "$TARGET_WALL_DIR" ] && [ "$(ls -A "$TARGET_WALL_DIR" 2>/dev/null)" ]; then
    TARGET_DIR="$TARGET_WALL_DIR"
else
    TARGET_DIR="$GENERAL_DIR"
fi

SFONDO=$(find "$TARGET_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf --random-source=/dev/urandom -n 1)

if [ -n "$SFONDO" ]; then
    awww img "$SFONDO" \
        --transition-type center \
        --transition-duration 2 \
        --transition-fps 60 \
        --transition-step 90
fi

# 9. Suono di notifica (Standard NixOS / Freedesktop)
NIXOS_SOUND="/run/current-system/sw/share/sounds/freedesktop/stereo/message.oga"

if [ -f "$NIXOS_SOUND" ]; then
    # Usa pw-play (PipeWire) oppure paplay per riprodurre il suono standard
    pw-play "$NIXOS_SOUND" &>/dev/null &
else
    # Fallback al campanello di sistema se il file non esiste
    printf '\a'
fi

notify-send \
    -u low \
    -a "Theme Switcher" \
    -i "$ICON" \
    "Tema Applicato" \
    "Attivato con successo: <b>$DISPLAY_NAME</b>"

# 11. Salva lo stato del tema corrente
echo "$THEME_NAME" >"$STATE_FILE"

echo "Tema applicato con successo: $THEME_NAME"
