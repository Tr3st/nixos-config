#!/usr/bin/env bash

THEME_NAME="$1"

if [ -z "$THEME_NAME" ]; then
    echo "Errore: Nessun tema specificato!"
    exit 1
fi

DOTFILES="$HOME/.dotfiles"
THEMES_DIR="$DOTFILES/themes"
PALETTE_DIR="$THEMES_DIR/palette"
TEMPLATES_DIR="$THEMES_DIR/templates"
CURRENT_SYMLINK="$PALETTE_DIR/current"
TARGET_THEME="$PALETTE_DIR/$THEME_NAME"
JSON_FILE="$TARGET_THEME/colors.json"

# 1. Crea le cartelle se non esistono
mkdir -p "$TARGET_THEME"
mkdir -p "$TARGET_THEME/wallpapers"

# 2. Se manca il colors.json, ne genera uno standard di fallback
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

# 3. Aggiorna il symlink 'current'
rm -rf "$CURRENT_SYMLINK"
ln -sfn "$TARGET_THEME" "$CURRENT_SYMLINK"

# 4. Funzione per estrarre valori dal JSON
get_json_val() {
    local key="$1"
    grep -oE "\"$key\"[[:space:]]*:[[:space:]]*\"[^\"]+\"" "$JSON_FILE" | head -n 1 | cut -d'"' -f4
}

NVIM_CS=$(get_json_val "nvim_colorscheme")
[ -z "$NVIM_CS" ] && NVIM_CS="$THEME_NAME"

# 5. Compilazione dei template
# 5. Compilazione sicura e atomica dei template
for tmpl in "$TEMPLATES_DIR"/*; do
    [ -f "$tmpl" ] || continue

    filename=$(basename "$tmpl")
    output_path="$TARGET_THEME/$filename"
    temp_output="${output_path}.tmp"

    # Copia il template nel file temporaneo
    cp "$tmpl" "$temp_output"

    # Sostituisce il colorscheme di Neovim se presente
    sed -i "s|{{nvim_colorscheme}}|$NVIM_CS|g" "$temp_output"

    # Legge riga per riga il colors.json e sostituisce i colori
    while IFS= read -r line; do
        if [[ "$line" =~ \"([a-zA-Z0-9_]+)\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
            key="${BASH_REMATCH[1]}"
            val="${BASH_REMATCH[2]}"

            clean_val="${val#\#}"

            sed -i "s|{{$key}}|$val|g" "$temp_output"
            sed -i "s|{{${key}_clean}}|$clean_val|g" "$temp_output"
        fi
    done <"$JSON_FILE"

    # Sposta il file definitivo in modo atomico (elimina ogni errore di lettura a metà)
    mv "$temp_output" "$output_path"
done

# 6. Ricarica Hyprland
hyprctl reload

# 7. Gestione Sfondi
TARGET_WALL_DIR="$TARGET_THEME/wallpapers"
GENERAL_DIR="$DOTFILES/general-wallpapers"

if [ -d "$TARGET_WALL_DIR" ] && [ "$(ls -A "$TARGET_WALL_DIR" 2>/dev/null)" ]; then
    TARGET_DIR="$TARGET_WALL_DIR"
else
    TARGET_DIR="$GENERAL_DIR"
fi

SFONDO=$(find "$TARGET_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf --random-source=/dev/urandom -n 1)

if [ -n "$SFONDO" ]; then
    awww img "$SFONDO" --transition-type fade --transition-duration 2
fi

# Invia un segnale a tutte le istanze di Kitty per ricaricare la configurazione
pkill -USR1 kitty

echo "Tema applicato con successo: $THEME_NAME"
