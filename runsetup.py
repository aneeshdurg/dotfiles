import os
import subprocess
import sys
import threading
from typing import IO

environ = os.environ
environ["BODO_FORCE_COLORED_BUILD"] = "1"

output = open(sys.argv[1], "w")

builder = subprocess.Popen(
    ["python3", "setup.py", "develop"],
    env=environ,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE
)

def reader(file: IO[bytes]):
    while not file.closed:
        line = file.readline().decode()
        if len(line) == 0:
            break
        print(line, end="")
        print(line, end="", file=output)

assert builder.stdout
assert builder.stderr
t1 = threading.Thread(target=reader, args=(builder.stdout,))
t1.start()
t2 = threading.Thread(target=reader, args=(builder.stderr,))
t2.start()

exitcode = builder.wait()
t1.join()
t2.join()

sys.exit(exitcode)
