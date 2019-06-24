#!/usr/bin/python3
import os
import sys
from multiprocessing import Process
from signal import alarm, signal, SIGALRM

request_pipe = os.path.expanduser("~/.i3/dunst_pipe")
output_state_pipe = os.path.expanduser("~/.i3/dunst_pipe_state")
def pause_manager():
    dunst_paused = False

    os.system("rm -rf " + request_pipe)
    os.mkfifo(request_pipe)
    os.system("rm -rf " + output_state_pipe)
    os.mkfifo(output_state_pipe)

    while True:
        with open(request_pipe) as request_fd:
            while True:
                line = request_fd.readline().strip()
                if (line == ""):
                    break
                if line == "pause" and not dunst_paused:
                    dunst_paused = True
                    os.system("notify-send DUNST_COMMAND_PAUSE")
                elif line == "resume" and dunst_paused:
                    dunst_paused = False
                    os.system("notify-send DUNST_COMMAND_RESUME")
                elif line == "toggle":
                    if dunst_paused:
                        os.system("notify-send DUNST_COMMAND_RESUME")
                    else:
                        os.system("notify-send DUNST_COMMAND_PAUSE")
                    dunst_paused = not dunst_paused
                elif line == "query":
                    with open(output_state_pipe, 'w') as state_output:
                        state_output.write("{}\n".format(dunst_paused))
def manage(fn):
    proc = Process(target=fn)
    proc.start()
    while True:
        proc.join()
        proc = Process(target=fn)
        proc.start()

if __name__ == "__main__":
    def usage():
        print("Usage: ./dunst_pause.py\
                [--start] [--pause] [--resume] [--query]")
        exit(1)

    if len(sys.argv) != 2:
        usage()

    if "--start" in sys.argv:
        manage(pause_manager)
        exit(1)

    def alarm_handler(signum, frame):
        print("Notifications ??????")
        #raise IOError("Manager not running")
        exit(0)
    signal(SIGALRM, alarm_handler)
    alarm(1)

    if "--pause" in sys.argv:
        open(request_pipe, 'w').write("pause\n")
    elif "--resume" in sys.argv:
        open(request_pipe, 'w').write("resume\n")
    elif "--toggle" in sys.argv:
        open(request_pipe, 'w').write("toggle\n")
    elif "--query" in sys.argv:
        open(request_pipe, 'w').write("query\n")
        state = open(output_state_pipe, 'r').readline().strip()
        if state == "True":
            print("Notifications Paused")
        else:
            print("Notifications Active")
    else:
        usage()
