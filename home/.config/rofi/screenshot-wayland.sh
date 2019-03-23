#!/bin/bash

ACTION=$(cat <<EOF | rofi -dmenu -p "screenshot: " -kb-custom-1 "Alt+Return"
All screens
Focused screen
Select area
EOF
)
EXIT="$?"

if [ "$EXIT" = "1" ]
then
    exit
fi

if [ "$EXIT" = "10" ]
then

    if [ "$ACTION" = "All screens" ]
    then
        grim - | wl-copy
    elif [ "$ACTION" = "Focused screen" ]
    then
        grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') | wl-copy
    elif [ "$ACTION" = "Select window or area" ]
    then
        grim -g "$(slurp)" | wl-copy
    fi

else

    mkdir -p ~/Pictures/Screenshots || exit
    cd ~/Pictures/Screenshots || exit

    if [ "$ACTION" = "All screens" ]
    then
        grim "$(date --iso-8601=seconds).png"
    elif [ "$ACTION" = "Focused screen" ]
    then
        grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') "$(date --iso-8601=seconds).png"
    elif [ "$ACTION" = "Select window or area" ]
    then
        grim -g "$(slurp)" "$(date --iso-8601=seconds).png"
    fi

fi
