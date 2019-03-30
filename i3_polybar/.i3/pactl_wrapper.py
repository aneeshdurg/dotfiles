import subprocess
import re

pactl_sinks_raw = subprocess.check_output("pactl list sinks".split()).decode()
pactl_sinks_raw = pactl_sinks_raw.split('\n')

pactl_sinks = dict()
sink = re.compile("^Sink #\d*$")
for line in pactl_sinks_raw:
    if sink.match(line):
        pactl_sinks[int(line.split('#')[1])] = dict()
