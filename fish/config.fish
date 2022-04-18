# A fish prompt that look suspiciously like the bash prompt
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

# redshift shortcuts
alias rsx='redshift -x'
alias rson='redshift -O 3500'
# configure view to work with nvim
alias view='nvim -R'
alias cat='batcat'

# Environment variables for go projects
set -x GOPATH /usr/share/go
set -gx PATH $PATH "$GOROOT"/bin "$GOPATH"/bin ^/dev/null
set -gx PATH /home/aneesh/workbin $PATH

function oops -d "Correct your previous console command"
  set -l bad_command $history[1]
  env TF_ALIAS=oops PYTHONIOENCODING=utf-8 thefuck $bad_command | read -l good_command
  if [ "$good_command" != "" ]
    eval $good_command
    builtin history delete --exact --case-sensitive -- $bad_command
    builtin history merge ^ /dev/null
  end
end

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

set -gx PATH /usr/local/bin/gradle $PATH

# source ~/.cargo/env

# Generated for envman. Do not edit.
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

zoxide init fish | source

set -x AWS_EC2_METADATA_DISABLED "true"
