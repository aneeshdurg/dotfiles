#! /usr/bin/python3

import subprocess

devices = subprocess.check_output(['xinput', 'list']).decode().split('\n')
devices = [dev for dev in devices if '06CB:CD73 Touchpad' in dev]

device = devices[0]
dev_id = device.split('=')[1].split()[0]

cmds = [
    ['xinput', 'set-prop', dev_id, 'libinput Click Method Enabled', '0', '1'],
    ['xinput', 'set-prop', dev_id, 'libinput Tapping Enabled', '1'],
    ['xinput', 'set-prop', dev_id, 'libinput Natural Scrolling Enabled', '1'],
    ['xset', 'r', 'rate', '200', '25']
]

for cmd in cmds:
    print(' '.join(cmd))
    subprocess.check_call(cmd)
