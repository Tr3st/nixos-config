#!/usr/bin/env bash

# Definisci le opzioni (senza icone strane che potrebbero rompere Wofi)
opzioni="Spegni\nRiavvia\nStandby\nLogout"

# Apri il dropdown nell'angolo in alto a destra
scelta=$(echo -e "$opzioni" | wofi --dmenu --cache-file /dev/null --width 200 --height 210 --prompt "Sistema" --location top_right --xoffset -15 --yoffset 60)

case $scelta in
"Spegni") systemctl poweroff ;;
"Riavvia") systemctl reboot ;;
"Standby") systemctl suspend ;;
"Logout") hyprctl dispatch exit ;;
esac
