# A fish prompt that looks suspiciously like the bash prompt
set -gx PATH /home/aneesh/.local/bin/ $PATH
set -gx PATH /home/aneesh/.local/bin/ $PATH
function fish_prompt
  echo -n (set_color --bold 9eef00)"$USER""@"(hostname)
  echo -n (set_color normal):
  echo -n (set_color --bold 5fafd7)(prompt_pwd)
  echo -n (set_color normal)

  if [ (id -u) -eq 0 ]
    echo -n "#"
  else
    echo -n "\$"
  end

  echo -n " "
end

# vi editing mode for maximum productivity
fish_vi_key_bindings

alias cat='bat'
alias sl='ls'

set -x GEM_HOME "$HOME/gems"
set -gx PATH $PATH "$HOME/gems/bin"

#                  _                  _       _        _ _
# _ _  ___ _____ _(_)_ __ ___ ____  _| |__ __| |_  ___| | |
#| ' \/ -_) _ \ V / | '  \___(_-< || | '_ (_-< ' \/ -_) | |
#|_||_\___\___/\_/|_|_|_|_|  /__/\_,_|_.__/__/_||_\___|_|_|
#
# The following section is utilities and logic regarding running a shell from
# within neovim.
#
# Most noteably is the getvim function which returns "nvim" if it's not in a
# subshell and "nvr -cc vsp" otherwise.

# requires https://github.com/mhinz/neovim-remote
# install using pip3 install neovim-remote
function getvim --description "return appropriate vim"
  if [ "$NVIM_ACTIVE" = "" ]
     echo "nvim"
  else
     echo "nvr -cc vsp"
  end
end

function nvim_header
  # Visual indicator that I'm in a neovim subshell
  if [ ! -z "$NVIM_ACTIVE" ]
    set_color green
    figlet -f small "NVIM SUBSHELL"
    set_color normal
  end
end

if [ -z "$NVIM_LISTEN_ADDRESS" ]
  set -x NVIM_LISTEN_ADDRESS /tmp/nvimsocket
end

set -x EDITOR (getvim)
if [ ! -z "$NVIM_ACTIVE" ]
  set -x EDITOR "$EDITOR --remote-wait"
  set -x HGEDITOR "/bin/hgeditor.sh"
end

# vim short cuts
function vim
    eval (getvim) $argv
end
complete -e -c vim
complete -F -c vim
# svim opens a file in a hsplit instead of a vsplit
if [ "$NVIM_ACTIVE" = "" ]
  alias svim='vim'
  alias tvim='vim'
  alias vcd='echo'
else
  alias svim='nvr -cc sp'
  alias tvim='nvr -cc tabe'
  function vcd
    nvr -cc (string join " " cd (realpath $argv[1]))
  end
end

function tmux_status -d "Print running tmux sessions"
  echo -ne "Running tmux sessions: \n\t\033[1;32m"
  tmux ls
  echo -ne "\033[0m"
end

function todo
  ~/dotfiles/todo.py ~/todo.txt $argv 2>/dev/null | bat --file-name todo -P
end

function todoe
  eval "$EDITOR ~/todo.txt"
  todo
end

function fish_greeting
  # Print out a random quote before yielding to the user
  ~/dotfiles/quotes.py

  nvim_header
  tmux ls 2>/dev/null >/dev/null; and tmux_status

  todo

  set VIM_SESSIONS (ls ~ | grep "\.vim\$" | tr ' ' '\n')
  if [ "$VIM_SESSIONS" != "" ]
    echo -ne "Saved vim sessions: \n\033[1;32m"
    ls ~ | grep "\.vim\$" | sed 's/^/\t/'
    echo -ne "\033[0m"
  end

  cat ~/.messages 2>/dev/null
end

function rename
  sed -i "s/"$argv[1]"/"$argv[2]"/g" (ag $argv[1] -l)
end

zoxide init fish | source

################################################################################
#        _ _
#   __ _(_) |_
#  / _` | | __|
# | (_| | | |_
#  \__, |_|\__|
#  |___/
# figlet: git
################################################################################
alias gp='git push origin (git rev-parse --abbrev-ref HEAD)'
alias gb='git branch'
alias gd='git diff'
alias gs='git status'
# interactive search git branches and checkout, or pick the closest match and
# checkout
function gc
  set cmd "fzy"
  if test (count $argv) -gt 0
    set cmd "fzy -e \"$argv\" | head -n 1"
    if test $argv[1] = "-"
      # gc - is like cd - => goes back to the previous checkout
      git checkout (
        git reflog | # scan reflog
        grep "HEAD@{[0-9]*}: checkout: " -A 1 | # find all checkouts
        head -n 1 | # Get most recent checkout
        rev | cut -d\  -f3 | rev # get the "from" name (blah blah blah... from <> to <>)
      )
      return
    end
  end
  set branch_name (gb | rev | cut -d\  -f 1 | rev | eval $cmd)
  git checkout $branch_name
end
################################################################################

################################################################################
#   ___ ___  _ __   __| | __ _
#  / __/ _ \| '_ \ / _` |/ _` |
# | (_| (_) | | | | (_| | (_| |
#  \___\___/|_| |_|\__,_|\__,_|
# figlet: conda
################################################################################
set -x CONDA_LEFT_PROMPT "true"
# hack for getting conda env vars to work in fish when switching envs
alias r='conda run --live-stream'
function ca
  conda activate $argv[1]
  for l in (r ~/dotfiles/export_conda_vars.py)
    eval $l 2>/dev/null || true
  end
end
################################################################################


set HOST_CONFIG ~/dotfiles/fish/(string split -f 1 '.' (hostname)).config.fish
if test -f $HOST_CONFIG
  source $HOST_CONFIG
end

function gcd --wraps 'cd'
  if test (count $argv) -eq 1
    if string match ":*" $argv[1]
      cd (git rev-parse --show-toplevel)(string sub --start=2 $argv[1])
      return
    end
  end
  builtin cd $argv
end

# Dangerous commands that are useful
alias drop_caches="echo 3 | sudo tee /proc/sys/vm/drop_caches"
alias disable_aslr="echo 0 | sudo tee /proc/sys/kernel/randomize_va_space"
alias enable_perf="echo -1 | sudo tee /proc/sys/kernel/perf_event_paranoid"
function gethuge
  cat /sys/kernel/mm/transparent_hugepage/enabled
end
function sethuge
  if not contains $argv[1] always madvise never
    echo "invalid usage" >&2
    return 1
  end
  echo $argv[1] | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
  gethuge
end
complete -c sethuge --no-files -ra 'always madvise never'

