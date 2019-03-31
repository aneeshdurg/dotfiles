# Controls media messages

option=""
if [ "$1" == "play" ]
then
    option="org.mpris.MediaPlayer2.Player.PlayPause"
else
  if [ "$1" == "next" ]; then
    option="org.mpris.MediaPlayer2.Player.Next"
  else
    if [ "$1" == "prev" ]; then
      option="org.mpris.MediaPlayer2.Player.Previous"
    fi
  fi
fi

dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 $option
