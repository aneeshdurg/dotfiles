#!/usr/bin/python3

import re
import subprocess

from multiprocessing import Process
from time import sleep

def monitor_battery():
    suspended = False
    interval = 60
    warn_count = 10
    while True:
        batt_status = subprocess.check_output(["acpi", "--battery"]).decode().strip()
        charging = "Charging" in batt_status
        level = int(re.split("(\d+)%", batt_status)[1])
        if not charging:
            if level <= 2:
                if not suspended:
                    subprocess.check_call([
                        "notify-send",
                        "Warning battery critical: {}% remaining!\nSuspending system!".format(level)])
                    interval = 1
                    warn_count -= 1

                    if warn_count == 0:
                        subprocess.check_call([
                            "/home/aneesh/.i3/locker.py", "suspend"])
                        suspended = True

            elif level < 5:
                subprocess.check_call([
                    "notify-send",
                    "Warning battery critical: {}% remaining!\nWill sleep soon!".format(level)])
                interval = 30

            elif level < 10:
                subprocess.check_call([
                    "notify-send",
                    "Warning battery low: {}% remaining!\nPlug in charger soon!".format(level)])
        else:
            suspended = False
            interval = 60
            warn_count = 10

        sleep(interval)

def detect_status_change():
    acpi_log = subprocess.Popen(["acpi_listen"], stdout=subprocess.PIPE)
    while True:
        l = acpi_log.stdout.readline()
        if not len(l):
            exit_status = acpi_log.wait()
            subprocess.check_call([
                "notify-send",
                "ACPI_LISTEN PROCESS FAILED {}".format(exit_status)])
            exit(1)
        msg = l.decode().strip()
        if "ac_adapter" in msg:
            status = int(msg.split()[-1])
            batt_status = subprocess.check_output(
                    ["acpi", "--battery"]).decode().strip()
            level = int(re.split("(\d+)%", batt_status)[1])
            verb = "charging" if status else "discharging"
            subprocess.check_call([
                "notify-send",
                "Battery {}\nCurrently at {}%".format(verb, level)])

if __name__ == "__main__":
    Process(target=detect_status_change).start()
    monitor_battery()
