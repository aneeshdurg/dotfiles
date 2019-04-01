#!/usr/bin/python3

import re
import subprocess

from time import sleep

def monitor_battery():
    suspended = False
    interval = 60
    while True:
        batt_status = subprocess.check_output(["acpi", "--battery"]).decode().strip()
        charging = "Charging" in batt_status
        level = int(re.split("(\d+)%", batt_status)[1])
        if not charging:
            if level < 2:
                if not suspended:
                    subprocess.check_call([
                        "notify-send",
                        "Warning battery critical: {}% remaining!\nSuspending system!".format(level)])
                    subprocess.check_call([
                        "/home/aneesh/.i3/locker.py", "suspend"])
                    suspended = True

            elif level < 5:
                subprocess.check_call([
                    "notify-send",
                    "Warning battery critical: {}% remaining!\nWill sleep soon!".format(level)])
                interval /= 2

            elif level < 10:
                subprocess.check_call([
                    "notify-send",
                    "Warning battery low: {}% remaining!\nPlug in charger soon!".format(level)])
        else:
            suspended = False
            interval = 60

        sleep(interval)

if __name__ == "__main__":
    monitor_battery()
