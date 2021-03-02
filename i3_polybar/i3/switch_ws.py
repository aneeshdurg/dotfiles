#!/usr/bin/python3
import json
import subprocess
import sys

outputs = json.loads(subprocess.check_output(['i3-msg', '-t', 'get_outputs']))
outputs = [o["name"] for o in outputs if o["active"]]

workspaces = json.loads(
    subprocess.check_output(['i3-msg', '-t', 'get_workspaces'])
)
curr_output = [w["output"] for w in workspaces if w["focused"]][0]
curr_output = outputs.index(curr_output)

arg = sys.argv[1]
if arg == "next":
    inc = 1
else:
    inc = -1

curr_output += inc
new_output = outputs[curr_output % len(outputs)]

subprocess.check_call([
    'i3-msg', 'move', 'workspace', 'to', 'output', new_output
])
