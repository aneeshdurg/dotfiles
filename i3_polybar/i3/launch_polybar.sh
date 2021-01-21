#!/bin/bash
pkill polybar
config=primary


readarray -t mirrors < <(xrandr --query | grep " connected" | grep -Eo '[0-9]+x[0-9]+\+[0-9]+\+[0-9]+')
if (( ${#mirrors[@]} == 2 )) && [[ "${mirrors[0]}" != "" && "${mirrors[0]}" == "${mirrors[1]}" ]]; then
config=mirrored
fi

for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload $config &
    if ~/.i3/is_mirrored.py;
    then
        break;
    fi
done
