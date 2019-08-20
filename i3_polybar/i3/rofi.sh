if ps axco command | grep rofi >/dev/null
then
  xdotool key Escape
else
  xdotool key super+space
fi
