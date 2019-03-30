#!/usr/bin/python3

import datetime
import subprocess
import sys

BAR_HEIGHT = 22  # polybar height
BORDER_SIZE = 1  # border size from your wm settings
YAD_WIDTH = 222  # 222 is minimum possible value
YAD_HEIGHT = 188 # 188 is minimum possible value

def get_output(prog):
    return subprocess.check_output(prog.split()).decode().strip()

if len(sys.argv) == 2 and sys.argv[1] == "--popup":
    if get_output("xdotool getwindowfocus getwindowname") == "yad-calendar":
        exit(0)

    # Defines X, Y, SCREEN, WINDOW
    exec(get_output("xdotool getmouselocation --shell"))

    # Defines WIDTH, HEIGHT
    exec(get_output("xdotool getdisplaygeometry --shell"))

    # X
    pos_x = None
    if (X + YAD_WIDTH/2 + 2 + BORDER_SIZE) > WIDTH: #Right side
        pos_x = WIDTH - YAD_WIDTH - BORDER_SIZE - 4
    elif (X - YAD_WIDTH/2 - 2 - BORDER_SIZE) < 1: #Left side
        pos_x = BORDER_SIZE
    else: #Center
        pos_x = X - YAD_WIDTH / 2 - 2

    # Y
    pos_y = None
    if Y > (HEIGHT / 2): #Bottom
        pos_y = HEIGHT - YAD_HEIGHT - 4 - BAR_HEIGHT - BORDER_SIZE
    else: #Top
        pos_y = BAR_HEIGHT + BORDER_SIZE

    pos_y += 13

    yad_command = [
            "yad",
            "--calendar",
            "--undecorated",
            "--fixed",
            "--close-on-unfocus",
            "--no-buttons",
            f"--width={YAD_WIDTH}",
            f"--height={YAD_HEIGHT}",
            f"--posx={pos_x}",
            f"--posy={pos_y}",
            "--title=\"yad-calendar\""]
    subprocess.Popen(yad_command, stdout=subprocess.DEVNULL)

else:
    print(datetime.datetime.now().strftime('%a %d %Y %H:%M'))

