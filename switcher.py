#! /usr/bin/python3
import subprocess
import sys

# list all workspaces
output = subprocess.check_output(["wmctrl", "-d"]).decode()
workspaces_raw = output.strip().split("\n")
workspaces = []
for ws in workspaces_raw:
    workspaces.append(list(filter(lambda x: len(x), ws.split()))[:2])

active_ws = None
for ws in workspaces:
    if ws[1] == '*':
        active_ws = int(ws[0])

assert active_ws is not None

if sys.argv[1] == 'next':
    target_ws = (active_ws + 1) % len(workspaces)
else:
    target_ws = (active_ws - 1) % len(workspaces)

subprocess.check_call(["wmctrl", "-s", str(target_ws)])
