#!/bin/bash

ACTION=$(cat <<EOF | wofi --dmenu -p "screenshot: "
All screens
All screens (clipboard)
Focused screen
Focused screen (clipboard)
Select area
Select area (clipboard)
EOF
)
EXIT="$?"

if [ "$EXIT" = "1" ]
then
    exit
fi

mkdir -p ~/Pictures/Screenshots || exit
cd ~/Pictures/Screenshots || exit

filename="$(date --iso-8601=seconds).png"

if [ "$ACTION" = "All screens" ]
then
    grim "${filename}"
elif [ "$ACTION" = "All screens (clipboard)" ]
then
    grim - | wl-copy
elif [ "$ACTION" = "Focused screen" ]
then
    grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" "${filename}"
elif [ "$ACTION" = "Focused screen (clipboard)" ]
then
    grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" - | wl-copy
elif [ "$ACTION" = "Select area" ]
then
    grim -g "$(slurp)" "${filename}"
elif [ "$ACTION" = "Select area (clipboard)" ]
then
    grim -g "$(slurp)" - | wl-copy
fi
