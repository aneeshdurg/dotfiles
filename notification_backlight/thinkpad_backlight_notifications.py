#!/usr/bin/python2 -u
# Needs to run with unbuffered python

"""
This script will flash the keyboard backlight when a notifcation is recieved.
The number of flashes/duration can be configured in 'config.json'.
Note that the parameter 'user' must be the user whose notifications should be
monitored.

Usage:
  sudo ./notifcations.py
"""


import glib
import dbus
import json
import subprocess
import sys

from dbus.mainloop.glib import DBusGMainLoop
from enum import Enum
from time import sleep

config = None

class KBDBacklightState(Enum):
    LOW = 0
    MED = 1
    HIGH = 2

# Just prints the brightness, the actual setting will be done by having stdout
# redirect to a sysfs file
def setBrightness(x):
    assert isinstance(x, KBDBacklightState)
    print(x.value)

def getBrightness():
    try:
        with open(config['backlight_path'], 'r') as f:
            data = int(f.read())
            return KBDBacklightState(data)
    except Exception as e:
        pass

# Listen for notifications
def notifications(bus, message):
    args_list = message.get_args_list()
    if not len(args_list):
        return

    orig = getBrightness()
    setBrightness(KBDBacklightState.LOW)

    for i in range(config['blink_count']):
        setBrightness(KBDBacklightState.LOW)
        sleep(config['blink_duration'])
        setBrightness(KBDBacklightState.HIGH)

    setBrightness(orig)

if __name__ == "__main__":
    config = json.load(open(
        '/home/aneesh/dotfiles/notification_backlight/config.json'))

    if '--run' in sys.argv:
        DBusGMainLoop(set_as_default=True)

        bus = dbus.SessionBus()
        bus.add_match_string_non_blocking(
                ", ".join([
                    "eavesdrop=true",
                    "interface='org.freedesktop.Notifications'",
                    "member='Notify'"]))
        bus.add_message_filter(notifications)

        mainloop = glib.MainLoop()
        mainloop.run()

    else:
        # Open the backlight unbuffered
        with open(config['backlight_path'], 'w', 0) as f:
            # Launch the script with the --run option as the user we want to
            # listen to
            # The script will be launched with stdout set to the backlight

            proc = subprocess.Popen( [
                        'su',
                        config['user'],
                        '-c',
                        ' '.join([sys.argv[0], '--run'])
                    ],
                    stdout=f)

            # Wait forever
            proc.wait()
        exit(0)
