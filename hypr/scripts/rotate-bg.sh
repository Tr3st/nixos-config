#!/usr/bin/env bash

# Tempo di attesa tra un cambio e l'altro (es. 600 = 10 minuti)
INTERVAL=600

while true; do
    # Definisci i due percorsi ad ogni ciclo, così si aggiornano dinamicamente
    THEME_DIR="$HOME/.dotfiles/themes/current/wallpapers"
    FALLBACK_DIR="$HOME/.dotfiles/general-wallpapers"

    # 1. Controlla se la cartella del tema esiste E se contiene dei file
    if [ -d "$THEME_DIR" ] && [ "$(ls -A "$THEME_DIR" 2>/dev/null)" ]; then
        TARGET_DIR="$THEME_DIR"

    # 2. Se fallisce, controlla la cartella generale di backup
    elif [ -d "$FALLBACK_DIR" ] && [ "$(ls -A "$FALLBACK_DIR" 2>/dev/null)" ]; then
        TARGET_DIR="$FALLBACK_DIR"

    # 3. Se non c'è nulla in nessuna delle due, aspetta 1 minuto e riprova
    else
        echo "Errore: Nessuno sfondo trovato in $THEME_DIR o in $FALLBACK_DIR"
        sleep 60
        continue
    fi

    # Trova tutte le immagini nella cartella vincitrice e scegline una a caso
    IMAGES=("$TARGET_DIR"/*)
    RANDOM_IMG="${IMAGES[RANDOM % ${#IMAGES[@]}]}"

    # Usa swww per cambiare sfondo con transizione
    swww img "$RANDOM_IMG" \
        --transition-type simple \
        --transition-step 90 \
        --transition-fps 60 \
        --transition-duration 2

    # Attendi prima del prossimo cambio
    sleep $INTERVAL
done
