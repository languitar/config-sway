#!/bin/bash

prompt="screenshot: "
if [ "$1" = "--delay" ]
then
  prompt="screenshot (5s delay): "
fi

ACTION=$(cat <<EOF | wofi --dmenu -p "${prompt}"
Everything
Current screen
Window
EOF
)
EXIT="$?"

if [ "$EXIT" = "1" ]
then
    exit
fi

if [ "$1" = "--delay" ]
then
  sleep 5
fi

mkdir -p ~/Pictures/Screenshots || exit
cd ~/Pictures/Screenshots || exit

filename="$(date --iso-8601=seconds).png"

if [ "$ACTION" = "Everything" ]
then
    grim -t ppm - | satty --filename - --output-filename "${filename}"
elif [ "$ACTION" = "Current screen" ]
then
    grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" -t ppm - | satty --filename - --output-filename "${filename}"
elif [ "$ACTION" = "Window" ]
then
    id=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | "\(.name) - \(.id)"' | wofi -p window --dmenu | tr ' - ' '\n' | tail -1)
    grim -g "$(swaymsg -t get_tree | jq -r ".. | select(.id?==${id}) | .rect | \"\(.x),\(.y) \(.width)x\(.height)\"")" -t ppm - | satty --filename - --output-filename "${filename}"
fi
