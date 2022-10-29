#!/usr/bin/env bash

set -e
set -o pipefail

if [ "${1}" = "--user" ]
then
    dmenu_prompt="Type username for"
else
    dmenu_prompt="Type password for"
fi

output="$(rbw list --fields name,user,folder | wofi --dmenu -p "${dmenu_prompt}")"

name="$(echo "${output}" | cut -f 1)"
user="$(echo "${output}" | cut -f 2)"
folder="$(echo "${output}" | cut -f 3)"

if [ -z "${name}" ]
then
    exit 1
fi

if [ "${1}" = "--user" ]
then
    echo "${user}"
else

    cmd=(get)

    if [ -n "${folder}" ]
    then
        cmd+=(--folder "${folder}")
    fi

    cmd+=("${name}")

    if [ -n "$user" ]
    then
        cmd+=("${user}")
    fi

    rbw "${cmd[@]}"

fi | { read -r pass; printf %s "$pass"; } | wtype -s 150 -
