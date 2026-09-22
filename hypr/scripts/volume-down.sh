#!/bin/bash
# Volume down with minimum limit of 9%
CURRENT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
NEW=$((CURRENT - 5))
if [ "$NEW" -lt 9 ]; then
    NEW=9
fi
wpctl set-volume @DEFAULT_AUDIO_SINK@ "${NEW}%"
