#!/usr/bin/env bash

THEME_NAME="$1"
DOTFILES="$HOME/.dotfiles"
PALETTE_DIR="$DOTFILES/themes/palette"
TEMPLATES_DIR="$DOTFILES/themes/templates"
CURRENT_SYMLINK="$PALETTE_DIR/current"
TARGET_THEME="$PALETTE_DIR/$THEME_NAME"
JSON_FILE="$TARGET_THEME/colors.json"

if [ ! -d "$TARGET_THEME" ]; then
    echo "Errore: Il tema $THEME_NAME non esiste in themes/palette/!"
    exit 1
fi

if [ ! -f "$JSON_FILE" ]; then
    echo "Errore: colors.json non trovato in $THEME_NAME!"
    exit 1
fi

# 1. Aggiorna il symlink del tema corrente dentro palette/
ln -sfn "$TARGET_THEME" "$CURRENT_SYMLINK"

# 2. Genera automaticamente i file di configurazione da TUTTI i file in templates/
for tmpl in "$TEMPLATES_DIR"/*; do
    [ -f "$tmpl" ] || continue

    filename=$(basename "$tmpl")
    output_file="$TARGET_THEME/${filename}-colors.conf"

    # Copia il file template come base
    cp "$tmpl" "$output_file"

    # Legge tutte le chiavi dal JSON e le sostituisce nel file di output
    while IFS="=" read -r key value; do
        key=$(echo "$key" | tr -d ' ",')
        value=$(echo "$value" | tr -d ' ",')

        if [ -n "$key" ] && [ -n "$value" ]; then
            sed -i "s|{{$key}}|$value|g" "$output_file"

            clean_val="${value#*#}"
            sed -i "s|{{${key}#\*#}}|$clean_val|g" "$output_file"
        fi
    done < <(jq -r '.colors | to_entries | .[] | "\(.key)=\(.value)"' "$JSON_FILE")
done

# 3. Ricarica Hyprland per applicare i colori
hyprctl reload

# 4. Gestione Sfondi
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

echo "Tema applicato con successo: $THEME_NAME"
