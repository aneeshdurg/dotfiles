#! /usr/bin/bash

eval $(xdotool getmouselocation --shell)
i3-msg '[id="'${WINDOW}'"] focus'
i3-msg workspace ${1}_on_output
