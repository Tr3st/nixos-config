#!/usr/bin/env bash

PALETTE_DIR="$HOME/.dotfiles/themes/palette"

selected_theme=$(find "$PALETTE_DIR" -mindepth 1 -maxdepth 1 -type d -exec test -f "{}/colors.json" \; -print |
    xargs -n1 basename | wofi --dmenu --prompt "Seleziona Tema:")

if [ -n "$selected_theme" ]; then
    "$HOME/.dotfiles/themes/scripts/apply-theme.sh" "$selected_theme"
fi
