# vim: set syntax=python
# pip install prompt-toolkit first!

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

$GEM_HOME = "$HOME/gems"
$PATH.append("$HOME/gems/bin")

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
