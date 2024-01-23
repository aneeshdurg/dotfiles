eval (/opt/homebrew/bin/brew shellenv)
# A fish prompt that looks suspiciously like the bash prompt
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

set -gx PATH /Users/aneesh/nvim-macos/bin/ $PATH
set -gx PATH /Users/aneesh/jdtls/bin/ $PATH

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


function tmux_status -d "Print running tmux sessions"
  echo -ne "Running tmux sessions: \n\t\033[1;32m"
  tmux ls
  echo -ne "\033[0m"
end

function fish_greeting
  # Print out a random quote before yielding to the user
  ~/dotfiles/.quotes.py

  nvim_header
  tmux ls 2>/dev/null >/dev/null; and tmux_status

  cat ~/todo.txt 2>/dev/null

  set VIM_SESSIONS (ls ~ | grep "\.*vim\$" | tr ' ' '\n')
  if [ "$VIM_SESSIONS" != "" ]
    echo -ne "Saved vim sessions: \n\033[1;32m"
    ls ~ | grep "\.*vim\$" | sed 's/^/\t/'
    echo -ne "\033[0m"
  end

  cat ~/.messages 2>/dev/null
end

function lszwin
    for pid in (xdotool search --class zoom)
        echo -n "$pid "
        xdotool getwindowname $pid
    end
end

function rename
  sed -i "s/"$argv[1]"/"$argv[2]"/g" (ag $argv[1] -l)
end

# Generated for envman. Do not edit.
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

zoxide init fish | source

# nvm
function nvm
   bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
end

set -x NVM_DIR ~/.nvm
nvm use default --silent


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
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/aneesh/mambaforge/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# hack for getting conda env vars to work in fish when switching envs
function ca
  conda activate $argv[1]
  for l in (r ~/.local/bin/export_conda_vars.py)
    eval $l
  end
end
################################################################################


################################################################################
#  _               _
# | |__   ___   __| | ___
# | '_ \ / _ \ / _` |/ _ \
# | |_) | (_) | (_| | (_) |
# |_.__/ \___/ \__,_|\___/
# figlet: bodo
################################################################################
# Enable detailed error messages for local development
set -x NUMBA_DEVELOPER_MODE 1
# Disable Python buffering
set -x PYTHONBUFFERED 1

function b
  pushd (git rev-parse --show-toplevel )
  env BODO_FORCE_COLORED_BUILD=1 python3 setup.py develop &| tee error.errs
  set retval $pipestatus[1]
  popd
  return $retval
end
function bsql
  pushd (git rev-parse --show-toplevel )/BodoSQL
  env BODO_FORCE_COLORED_BUILD=1 python3 setup.py develop &| tee ../error_bsql.errs
  set retval $pipestatus[1]
  popd
  return $retval
end

function sg
  pushd (git rev-parse --show-toplevel )
  ag \
    --ignore BodoSQL/calcite_sql/bodosql-calcite-application/src/test/resources/com/bodosql/calcite/application/_generated_files/ \
    --ignore BodoSQL/calcite_sql/bodosql-calcite-application/src/test/resources/com/bodosql/calcite/application/table_schemas/ \
    $argv
  popd
end
################################################################################
