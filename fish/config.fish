# A fish prompt that look suspiciously like the bash prompt
function fish_prompt
  echo -n (set_color --bold green)"$USER""@"(hostname)
  echo -n (set_color normal):
  echo -n (set_color --bold blue)(prompt_pwd)
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
# bind '"\e[1;5D" backward-word'
# bind '"\e[1;5C" forward-word'

# redshift shortcuts
alias rsx='redshift -x'
alias rson='redshift -O 3500'
# configure view to work with nvim
alias view='nvim -R'
# compilers/frameworks
alias ldc='ldc2'
# I don't want node-js in my path, so I've made aliases to things I want to use.
alias react-native='/usr/bin/nodejs8/bin/react-native'
alias create-react-native='/usr/bin/nodejs8/bin/create-react-native'
# Alias for the wu-tan name generator - didn't think this needed to be in PATH
alias wu-tang='~/dotfiles/wu-tang.sh'

alias t='tmux attach; or tmux'

# Environment variables for go projects
set -x GOPATH /usr/share/go
set -gx PATH $PATH "$GOROOT"/bin "$GOPATH"/bin ^/dev/null
set -gx PATH /opt/qumulo/toolchain/bin $PATH

function oops -d "Correct your previous console command"
  set -l bad_command $history[1]
  env TF_ALIAS=oops PYTHONIOENCODING=utf-8 thefuck $bad_command | read -l good_command
  if [ "$good_command" != "" ]
    eval $good_command
    builtin history delete --exact --case-sensitive -- $bad_command
    builtin history merge ^ /dev/null
  end
end

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
alias vim='eval (getvim)'

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

  set VIM_SESSIONS (ls ~ | grep "\.*vim\$" | tr ' ' '\n')
  if [ "$VIM_SESSIONS" != "" ]
    echo -ne "Saved vim sessions: \n\033[1;32m"
    ls ~ | grep "\.*vim\$" | sed 's/^/\t/'
    echo -ne "\033[0m"
  end

  cat ~/.messages 2>/dev/null
end

# if [ "$NVIM_ACTIVE" != "" ]
#   function ag -d "Alias for ag"
#     command ag $argv
#       nvr -c 'let @/="'$argv[-1]'"'
#   end
# end

function files
  nautilus $argv 2>/dev/null >/dev/null &
end

function cd --description 'Change directory'
    set -l MAX_DIR_HIST 25

    if test (count $argv) -gt 1
        printf "%s\n" (_ "Too many args for cd command")
        return 1
    end

    # Skip history in subshells.
    if status --is-command-substitution
        builtin cd $argv
        return $status
    end

    # Avoid set completions.
    set -l previous $PWD

    if test "$argv" = "-"
        prevd
        return $status
    end

    if test "$argv" = "+"
        nextd
        return $status
    end

    builtin cd $argv
    set -l cd_status $status

    if test $cd_status -eq 0 -a "$PWD" != "$previous"
        set -q dirprev
        or set -l dirprev
        set -q dirprev[$MAX_DIR_HIST]
        and set -e dirprev[1]
        set -g dirprev $dirprev $previous
        set -e dirnext
        set -g __fish_cd_direction prev
    end

    return $cd_status
end


# Source qumulo specific aliases/functions/etc
set -x QUMULO 'true'

set -x QENV (ls /opt/qumulo/env | tail -1)
source ~/dotfiles/fish/qrc.fish
