#!/bin/bash

set -e
set -o pipefail

account="$(ykman oath accounts list | wofi --dmenu -p "OTP account" EOF)"

ykman oath accounts code -s "${account}" | tr -d '\n' | wtype -s 150 -

