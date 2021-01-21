import subprocess
import sys

from datetime import datetime

while True:
    with open("/tmp/keyb.log", 'a+') as f:
        f.write("listening to socket\n")

    something = sys.stdin.readline()
    subprocess.check_call(['xset', 'r', 'rate', '200', '25'])

    with open("/tmp/keyb.log", 'a+') as f:
        f.write("{}: {}\n".format(
            datetime.now(), something
        ))
