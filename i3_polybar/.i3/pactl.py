from sys import argv
import pulsectl

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
            vol = max(sink.volume.values)
            if vol >= 1 and increment > 0:
                exit(1)
            elif vol <= 0 and increment < 0:
                exit(1)
            offset = (vol  % 0.05)
            tol = 0.0001
            if (offset > tol and offset < (0.05 - tol)):
                pulse.volume_change_all_chans(sink, -1 * (vol  % 0.05))
            pulse.volume_change_all_chans(sink, increment)
        else:
            pulse.mute(sink, mute=sink.mute==0)
