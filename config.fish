# vi editing mode for maximum productivity
fish_vi_key_bindings

# # Commonly used colors for use inside echo statements
set -x ANSI_BLUE   "\033[0;34m"
set -x ANSI_YELLOW "\033[0;33m"
set -x ANSI_GREEN  "\033[0;32m"
set -x ANSI_RED    "\033[0;31m"
set -x ANSI_NC     "\033[0m"

# Kinda useful for picking a color
function print_all_colors --description "Looping through all colors for future reference"
     for x in (seq 30 37)
         for y in (seq 1 2)
             echo -ne "\033[$y;$xm█\033[0m"
         end
     end
     echo ""
end

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

# Environment variables for go projects
set -x GOPATH /usr/share/go
set -x PATH "$PATH":"$GOROOT"/bin:"$GOPATH"/bin ^/dev/null

# TODO
# # Z is useful for jumping around directories
# source ~/dotfiles/z/z.sh
#
# # Some script I wrote for editing and compiling latex
# source ~/dotfiles/vimedit.sh
# latex_watch ()
# {
#     inotifywait -m -e modify -r . |
#       tee |
#       grep --color=auto --line-buffered 'MODIFY .*.tex' | {
#         while read line; do
#             timeout 2 make;
#         done
#     }
# }

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

# Visual indicator that I'm in a neovim subshell
if [ ! -z "$NVIM_ACTIVE" ]
    echo -e "$ANSI_GREEN"
    figlet -f small "NVIM SUBSHELL"
    echo -e "$ANSI_NC"

end

# requires https://github.com/mhinz/neovim-remote
# install using pip3 install neovim-remote
function getvim --description "return appropriate vim"
    if [ "$NVIM_ACTIVE" = "" ]
       echo "nvim"
    else
       echo "nvr -cc vsp"
    end
end

if [ -z "$NVIM_LISTEN_ADDRESS" ]
then
    set -x NVIM_LISTEN_ADDRESS /tmp/nvimsocket
end

set -x EDITOR (getvim)
if [ ! -z "$NVIM_ACTIVE" ]
    set -x EDITOR "$EDITOR --remote-wait"
end
set -x HGEDITOR $EDITOR

# vim short cuts
alias vim='eval (getvim)'

# Print out a random quote before yielding to the user
~/dotfiles/.quotes.py

function tmux_status -d "Print running tmux sessions"
    echo -ne "Running tmux sessions: \n\t\033[1;32m"
    tmux ls
    echo -ne "\033[0m"
end
tmux ls 2>/dev/null >/dev/null; and tmux_status

set VIM_SESSIONS (ls ~ | grep "\.*vim\$" | tr ' ' '\n')
if [ "$VIM_SESSIONS" != "" ]
  echo -ne "Saved vim sessions: \n\033[1;32m"
  ls ~ | grep "\.*vim\$" | sed 's/^/\t/'
  echo -ne "\033[0m"
end


#TMUX_PROG='nvim -c "terminal"'
#[ "$TMUX" != "" ] && [ "$NVIM_ACTIVE" == "" ] && exec $TMUX_PROG
# bind '"\e[1;5D" backward-word'
# bind '"\e[1;5C" forward-word'

cat ~/.messages 2>/dev/null
