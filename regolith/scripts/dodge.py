#!/bin/python

import argparse
import atexit
import os
import signal
import subprocess
import time
from multiprocessing import Process
from pathlib import Path


def get_window_geom():
    width, height = (
        subprocess.check_output(["xdotool", "getdisplaygeometry"])
        .decode()
        .strip()
        .split()
    )
    return int(width), int(height)


def get_window_location(window_id) -> tuple[tuple[int, int], tuple[int, int]]:
    win_geom = subprocess.check_output(
        ["xdotool", "getwindowgeometry", str(window_id)]
    ).decode()
    win_geom = win_geom.split("\n")
    pos = [int(z) for z in win_geom[1].split(":")[1].strip().split()[0].split(",")]
    geom = [int(z) for z in win_geom[2].split(":")[1].strip().split()[0].split("x")]
    return (pos[0], pos[1]), (geom[0], geom[1])


def get_active_wid() -> int:
    return int(subprocess.check_output(["xdotool", "getactivewindow"]).decode())


def wait_for_window_close(wid: int):
    p = subprocess.Popen(
        ["xprop", "-spy", "-id", str(wid)],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return p


def cleanup(p: subprocess.Popen):
    p.kill()
    p.wait()


def daemon(window_id: int, procfile: Path):
    print("creating proc file")
    with procfile.open("w") as f:
        f.write(str(os.getpid()))

    print("getting w/h")
    width, height = get_window_geom()

    p = wait_for_window_close(window_id)
    atexit.register(lambda: cleanup(p))

    print("starting loop")
    while p.poll() is None:
        time.sleep(0.01)

        if get_active_wid() == window_id:
            # print("skip (active)")
            # disable dodging while the window is in focus
            continue

        # print("detect?")
        _, _, _screen, wid = subprocess.check_output(
            ["xdotool", "getmouselocation"]
        ).split()
        wid = int(wid.decode().split(":")[1])
        # print("  ", wid, window_id)
        if wid == window_id:
            # move the window far away
            ((x, y), (w, h)) = get_window_location(window_id)

            # find which corner we're closest to and move to the next
            # corner

            # we're using manhattan distance here for each corner
            _d, closest_corner = min(
                (x + y, 0),
                (x + (height - (y + h)), 1),
                ((width - (x + w)) + y, 2),
                ((width - (x + w)) + (height - (y + h)), 3),
            )
            target_corner = (closest_corner + 1) % 4

            target_x = 0
            target_y = 0
            if target_corner == 0:
                pass
            elif target_corner == 1:
                target_y = height - h
            elif target_corner == 2:
                target_x = width - w
            elif target_corner == 3:
                target_y = height - h
                target_x = width - w
                pass

            # print("move", window_id, target_x, target_y)
            subprocess.check_call(
                [
                    "xdotool",
                    "windowmove",
                    str(window_id),
                    str(target_x),
                    str(target_y),
                ]
            )


PROC_DIR = Path("/home/aneesh/.cache/dodge_procs")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--window-id", required=False, action="store")
    args = parser.parse_args()

    os.makedirs(PROC_DIR, exist_ok=True)
    if not (wid := args.window_id):
        wid = str(get_active_wid())
    print("wid=", wid)

    proc = PROC_DIR / wid
    if proc.exists():
        print("killing...")
        pid = int(proc.open().read())
        try:
            os.kill(pid, signal.SIGTERM)
        except ProcessLookupError:
            pass
        proc.unlink()
    else:
        print("spawning...")
        p = Process(target=daemon, args=(int(wid), proc))
        p.daemon = True
        p.start()
        os._exit(0)
