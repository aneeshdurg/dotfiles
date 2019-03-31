#!/usr/bin/python3
""" Controls backlight """

import subprocess
import sys

curr = int(
    round(
        float(subprocess.check_output("xbacklight -get".split()).decode())))

inc = 0
if sys.argv[1] == "inc":
    inc = 5
elif sys.argv[1] == "dec":
    inc = -5

if inc:
    if curr >= 100 and inc > 0:
        exit(1)
    elif curr <= 0 and inc< 0:
        exit(1)

    curr -= curr % 5
    curr += inc
    subprocess.check_call("xbacklight -set {}".format(curr).split())
