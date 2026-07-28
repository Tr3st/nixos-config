#!/usr/bin/env bash

THEME_NAME="$1"
THEMES_DIR="$HOME/.dotfiles/themes"
CURRENT_SYMLINK="$THEMES_DIR/current"
TARGET_THEME="$THEMES_DIR/$THEME_NAME"

TARGET_WALL_DIR="$TARGET_THEME/wallpapers"
GENERAL_DIR="$HOME/.dotfiles/general-wallpapers"

if [ ! -d "$TARGET_THEME" ]; then
    echo "Errore: Il tema $THEME_NAME non esiste!"
    exit 1
fi

# 1. Aggiorna il symlink del tema corrente (usato anche da wallpaper.sh)
ln -sfn "$TARGET_THEME" "$CURRENT_SYMLINK"

# 2. Ricarica Hyprland per applicare i colori
hyprctl reload

# 3. Applica subito lo sfondo del nuovo tema appena scelto
if [ -d "$TARGET_WALL_DIR" ] && [ "$(ls -A "$TARGET_WALL_DIR" 2>/dev/null)" ]; then
    TARGET_DIR="$TARGET_WALL_DIR"
else
    TARGET_DIR="$GENERAL_DIR"
fi

SFONDO=$(find "$TARGET_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf --random-source=/dev/urandom -n 1)

if [ -n "$SFONDO" ]; then
    awww img "$SFONDO" \
        --transition-type fade \
        --transition-duration 2 \
        --transition-fps 60 \
        --transition-bezier .43,1.19,1,.4
fi

# 4. Notifica a schermo (se disponibile)
if command -v notify-send &>/dev/null; then
    notify-send "Tema Applicato" "Passato a: $THEME_NAME"
else
    echo "Tema Applicato: $THEME_NAME"
fi
