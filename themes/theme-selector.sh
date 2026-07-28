#!/usr/bin/env bash

THEMES_DIR="$HOME/.dotfiles/themes"

# Trova tutte le cartelle dei temi disponibili
selected_theme=$(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | wofi --dmenu --prompt "Seleziona Tema:")

if [ -n "$selected_theme" ]; then
    # Lancia lo script che applica il tema scelto
    "./apply-theme.sh" "$selected_theme"
fi
