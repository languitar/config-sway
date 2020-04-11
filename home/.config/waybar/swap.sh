#!/bin/sh

percentage=$(free | grep 'Swap' | awk '{t = $2; u = $3; print ((u/t) * 100.0)}')

used=$(free -h | grep 'Swap' | awk '{t = $2; u = $3; printf("%s/%s used", u, t)}')

echo '{"text": "ignored", "tooltip": "'"${used}"'", "percentage": '"${percentage}"'}'
