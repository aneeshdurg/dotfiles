#!/usr/bin/python3
import i3ipc
import subprocess
from time import sleep
from multiprocessing import Process

def run_urgent_switch():
    def urgency(i3, e):
        if e.change == "urgent" and e.container.name != "Signal":
            subprocess.check_call(["i3-msg", '[urgent="latest"] focus'])
    i3 = i3ipc.Connection()
    i3.on('window::urgent', urgency)
    i3.main()

def manage(fn):
    proc = Process(target=fn)
    proc.start()
    while True:
        proc.join()
        proc = Process(target=fn)
        proc.start()

if __name__ == "__main__":
    manage(run_urgent_switch)
