#!/usr/bin/env bash

THEME_NAME="$1"
THEMES_DIR="$HOME/.dotfiles/themes"
CURRENT_SYMLINK="$THEMES_DIR/current"
TARGET_THEME="$THEMES_DIR/$THEME_NAME"

if [ ! -d "$TARGET_THEME" ]; then
    notify-send "Errore Tema" "Il tema $THEME_NAME non esiste!"
    exit 1
fi

# 1. Aggiorna il symlink del tema corrente
ln -sfn "$TARGET_THEME" "$CURRENT_SYMLINK"

# 2. Applica i colori (qui aggiorni i file di configurazione o richiami le config del tema)
# Esempio: ricarica Hyprland
hyprctl reload

# 3. Cambia wallpaper scegliendone uno a caso dalla cartella del tema attivo
WALLPAPER=$(find "$TARGET_THEME/wallpapers" -type f | shuf -n 1)

if [ -n "$WALLPAPER" ]; then
    # Se usi swww per gestire gli sfondi:
    swww img "$WALLPAPER" --transition-type grow --transition-duration 2

    # Salva lo sfondo corrente per futuri script o riavvii
    echo "$WALLPAPER" >"$HOME/.cache/current_wallpaper"
fi

notify-send "Tema Applicato" "Passato a: $THEME_NAME"
