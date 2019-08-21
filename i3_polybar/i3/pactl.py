#!/usr/bin/python3
""" Volume control wrapper around pulsectl """

from sys import argv
import pulsectl
import subprocess

BELL_SOUND = "/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"

increment = 0
if argv[1] == "up":
    increment = 0.05
elif argv[1] == "down":
    increment = -0.05
elif argv[1] != "mute":
    exit(1)

with pulsectl.Pulse('volume-increaser') as pulse:
    for sink in pulse.sink_list():
        if increment:
            delta = increment
            vol = max(sink.volume.values)
            if vol >= 1 and increment > 0:
                delta = 0
            elif vol <= 0 and increment < 0:
                delta = 0

            offset = (vol  % 0.05)
            tol = 0.0001
            if (offset > tol and offset < (0.05 - tol)):
                pulse.volume_change_all_chans(sink, -1 * (vol  % 0.05))

            pulse.volume_change_all_chans(sink, delta)

            if (sink.mute == 1):
                pulse.mute(sink, mute=False)

        else:
            pulse.mute(sink, mute=sink.mute==0)

if increment:
    subprocess.check_call(["paplay", BELL_SOUND])
