#!/usr/bin/env bash

# Definisci le opzioni del menù
opzioni="⏻ Spegni\n Riavvia\n Esci (Log Out)"

# Apri Wofi in modalità menù testuale
scelta=$(echo -e "$opzioni" | wofi --dmenu --cache-file /dev/null --width 300 --height 220 --prompt "Sistema:")

# Esegui l'azione in base a cosa hai cliccato o premuto con Invio
case $scelta in
"⏻ Spegni") systemctl poweroff ;;
" Riavvia") systemctl reboot ;;
" Esci (Log Out)") hyprctl dispatch exit ;;
esac
