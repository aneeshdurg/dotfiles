import re
from xonsh.history.main import construct_history

with open(".local/share/fish/fish_history") as history_file:
    history_lines = history_file.readlines()

hist = construct_history(
	gc=False,
	# exlictily set buffersize to prevent slowing down to a crawl because of excessive flushing
	buffersize=len(history_lines)
)

for i in range(len(history_lines)):
    line = history_lines[i];
    if not line.startswith("-"):
        continue

    cmd = line.split("cmd:")[1].strip()
    timestamp = int(history_lines[i + 1].split(":")[1].strip())
    print(cmd, timestamp)
    hist.append({
        'inp': cmd,
        'rtn': 0,
        'ts': (timestamp, timestamp)
    })
hist.flush()
print(hist.info().filename)
