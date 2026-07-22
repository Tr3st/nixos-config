#!/usr/bin/env bash

# Le 4 opzioni essenziali
opzioni="⏻  Spegni\n  Riavvia\n⏾  Standby\n  Logout"

# Wofi configurato come un dropdown menu in alto a destra
scelta=$(echo -e "$opzioni" | wofi --dmenu --cache-file /dev/null --width 200 --height 210 --prompt "Sistema" --location top_right --xoffset -10 --yoffset 45)

case $scelta in
"⏻  Spegni") systemctl poweroff ;;
"  Riavvia") systemctl reboot ;;
"⏾  Standby") systemctl suspend ;;
"  Logout") hyprctl dispatch exit ;;
esac
