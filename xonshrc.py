# vim: set syntax=python
# pip install prompt-toolkit first!

import xonsh.jobs
import builtins

import json

from math import *
from termcolor import colored

xontribs = [
    "abbrevs",
    "coreutils",
    "fzf-widgets",
    "z"
]
for x in xontribs:
    xontrib load @(x)

$AUTO_CD = True
$VI_MODE = True
$PROMPT = '{env_name}{BOLD_GREEN}{user}@{hostname}{RESET}:{BOLD_BLUE}{cwd}{RESET}{prompt_end}{RESET} '
$fzf_history_binding = "c-r"  # Ctrl+R
$fzf_file_binding = "c-f"

# redshift shortcuts
abbrevs['rsx']='redshift -x'
abbrevs['rson']='redshift -O 3500'
# configure view to work with nvim
abbrevs['view']='nvim -R'
aliases['cat'] = 'batcat'

$GEM_HOME = f"{$HOME}/gems"
$PATH.append("$HOME/gems/bin")
$PATH.append("/usr/local/cuda-11.2/")

def getvim():
    if 'NVIM_ACTIVE' in ${...}:
        return 'nvr -cc vsp'
    else:
        return 'nvim'

def nvim_header():
      # Visual indicator that I'm in a neovim subshell
    if 'NVIM_ACTIVE' in ${...}:
        output = $(figlet -f small "NVIM SUBSHELL")
        print(colored(output, 'green'))

if "NVIM_LISTEN_ADDRESS" not in ${...}:
  $NVIM_LISTEN_ADDRESS = p"/tmp/nvimsocket"

$EDITOR = getvim()
if 'NVIM_ACTIVE' in ${...}:
  $EDITOR  = f"{getvim()} --remote-wait"
  $HGEDITOR = "/bin/hgeditor.sh"

aliases['vim'] = getvim()

def tmux_status():
    echo -ne "Running tmux sessions: \n\t\033[1;32m"
    tmux ls
    echo -ne "\033[0m"

def startup():
    ~/dotfiles/.quotes.py

    nvim_header()

    tmux ls err>/dev/null o>/dev/null && tmux_status()
startup()

orig_z = aliases['z']
def _z(args=[]):
    if args:
        return orig_z(args)
    else:
        return orig_z([""])
aliases['z'] = _z

def _disown(args, stdin=None):
    """xonsh command: disown
    Remove background jobs from xonsh shell handling so that they will continue
    running after the shell exits.
    an arbitrary number of jobIDs may be specified as arguments. If no
    arguments are specified, all jobs will be disowned.
    """

    if len(xonsh.jobs.tasks) == 0:
        return "", "There are no active jobs"

    if len(args) > 0:
        try:
            to_disown = [xonsh.jobs.tasks[tid]
                    for argv in args if (tid := int(argv) - 1) >= 0]
        except ValueError:
            return "", "One or more jobsIDs is invalid: {}\n".format(args)
    else:
        return "", "Must specify 1 or more job IDs."

    for tid in to_disown:
        current_task = xonsh.jobs.get_task(tid)
        # Resume the task in case it is paused
        xonsh.jobs._continue(current_task)

        # Stop tracking this task
        xonsh.jobs.tasks.remove(tid)
        del builtins.__xonsh__.all_jobs[tid]
        # the shell won't exit normally if there are disowned procs, but the
        # procs continue to run..
        current_task['obj'].proc.poll = lambda: True
        current_task['obj'].poll = lambda: 0
aliases['disown'] = _disown

abbrevs['fixrzr'] = 'sudo usbhid-dump -m 1532'
abbrevs['fixrate'] = 'xset r rate 200 25'

$HISTCONTROL = "ignorespace"
