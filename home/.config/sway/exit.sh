#! /bin/bash

function close_windows {
    swaymsg '[class="^.*$"]' kill
    sleep 2
}

op=$(printf "Shutdown\nReboot\nSuspend\nExit sway" | wofi --dmenu -i -p "Select Option")
if [ "$op" = "Shutdown" ]; then
    close_windows
    systemctl poweroff
elif [ "$op" = "Reboot" ]; then
    close_windows
    systemctl reboot
elif [ "$op" = "Suspend" ]; then
    systemctl suspend
elif [ "$op" = "Exit sway" ]; then
    swaymsg 'exit'
fi
