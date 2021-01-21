#!/usr/bin/python3
""" Controls backlight """

import subprocess
import sys

BL_PATH = "/sys/class/backlight/intel_backlight/brightness"
MAX_BL_PATH = "/sys/class/backlight/intel_backlight/max_brightness"

with open(BL_PATH) as f:
    curr = int(f.read())
with open(MAX_BL_PATH) as f:
    max_brightness = int(f.read())

step = 1000

inc = 0
if sys.argv[1] == "inc":
    inc = step
elif sys.argv[1] == "dec":
    inc = -step

if inc:
    curr -= curr % step
    curr += inc
    curr = max(min(curr, max_brightness), 0)
    with open(BL_PATH, 'w') as f:
        f.write(str(curr))
