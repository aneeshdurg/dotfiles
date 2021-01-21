#! /usr/bin/python3
import subprocess
import sys

monitors = subprocess.check_output(['xrandr', '--listmonitors'])
monitors = monitors.decode().strip().split('\n')
monitors = monitors[1:]

positions = ['-'.join(monitor.split('/')[2].split(' ')[0].split('+')[1:])
        for monitor in monitors]

if len(set(positions)) == 1:
    sys.exit(0)
else:
    sys.exit(1)
