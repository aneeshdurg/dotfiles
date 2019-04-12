#!/usr/bin/python3
""" A simple script to auto-suspend the laptop when locked """

import re
import subprocess
import sys

from time import sleep

def check_suspend():
    gsc_time_cmd = "gnome-screensaver-command -t".split()
    last_seen = 0
    counter = 0
    while True:
        time_output = subprocess.check_output(gsc_time_cmd).decode()
        if "active" in time_output:
            try:
                active_for = int(re.split("(\d+)", time_output)[1])
            except:
                break
            if active_for == 0:
                sleep(1)
            elif (active_for % 60) == 0 or\
                    (active_for - (active_for % 60)) > last_seen:
                last_seen = active_for
                subprocess.check_call("systemctl suspend".split())
            else:
                last_seen = active_for
            sleep(5)

def lock(suspend=True, suspend_now=False):
  subprocess.check_call("gnome-screensaver-command -l".split())
  if suspend_now:
    subprocess.check_call("systemctl suspend".split())
  elif suspend:
    check_suspend()

def main():
    if len(sys.argv) != 2:
        sys.argv = [sys.argv[0], "lock"]

    if sys.argv[1] == "lock":
        lock()
    elif sys.argv[1] == "logout":
        subprocess.check_call("i3-msg exit".split())
    elif sys.argv[1] == "suspend":
        lock(suspend_now=True)
    elif sys.argv[1] == "hibernate":
        lock(suspend=False)
        subprocess.check_call("systemctl hibernate".split())
    elif sys.argv[1] == "reboot":
        subprocess.check_call("systemctl reboot".split())
    elif sys.argv[1] == "shutdown":
        subprocess.check_call("systemctl poweroff".split())
    else:
        print("Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}")
        exit(2)

if __name__ == "__main__":
    main()
