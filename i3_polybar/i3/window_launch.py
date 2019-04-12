#!/usr/bin/python3

import subprocess

from time import time

rofi_command = "rofi -show-icons -show window"
open("/home/aneesh/w_l.log", "a").write(str(time()) + '\n')
try:
    xdotool_output = subprocess.check_call("xdotool search --name rofi".split())
    subprocess.check_call("xdotool key Escape".split())
    subprocess.call("pkill rofi".split())
except:
    subprocess.check_call(rofi_command.split())
