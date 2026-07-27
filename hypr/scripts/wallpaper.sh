#!/usr/bin/env bash

# ==========================================
# CONFIGURAZIONE MOTORE SFONDI
# ==========================================

THEME_DIR="$HOME/.dotfiles/themes/current/wallpapers"
GENERAL_DIR="$HOME/.dotfiles/general-wallpapers"

# Tempo di attesa tra una transizione e l'altra (in secondi). 300 = 5 minuti.
INTERVAL=300

# Loop infinito per la rotazione
while true; do

    # LOGICA DI FALLBACK:
    # Se la cartella del tema esiste ed ha almeno un file dentro, usala.
    # Altrimenti, passa alla cartella general-wallpapers.
    if [ -d "$THEME_DIR" ] && [ "$(ls -A "$THEME_DIR" 2>/dev/null)" ]; then
        TARGET_DIR="$THEME_DIR"
    else
        TARGET_DIR="$GENERAL_DIR"
    fi

    # Seleziona un'immagine a caso dalla cartella scelta
    SFONDO=$(find "$TARGET_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)

    # Verifica di aver trovato effettivamente un'immagine prima di lanciare il comando
    if [ -n "$SFONDO" ]; then
        # Esegue la transizione
        awww img "$SFONDO" \
            --transition-type fade \
            --transition-duration 2 \
            --transition-fps 60 \
            --transition-bezier .43,1.19,1,.4
    fi

    # Mette in pausa lo script fino al prossimo ciclo
    sleep $INTERVAL

done
