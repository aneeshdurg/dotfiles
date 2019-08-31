# vi editing mode for maximum productivity
set -o vi

# Setting env var so that vim config will behave differently
export QUMULO='true'

# Commonly used colors for use inside echo statements
export ANSI_BLUE="\033[0;34m"
export ANSI_YELLOW="\033[0;33m"
export ANSI_GREEN="\033[0;32m"
export ANSI_RED="\033[0;31m"
export ANSI_NC="\033[0m"

# Looping through all colors for future reference
# Kinda useful for picking a color
print_all_colors() {
    for x in {30..37}
    do
        for y in {1..2}
            do echo -ne "\033[${y};${x}m█\033[0m"
        done
    done
    echo ""
}

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
export GOPATH=/usr/share/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Z is useful for jumping around directories
source ~/dotfiles/z/z.sh

# Some script I wrote for editing and compiling latex
source ~/dotfiles/vimedit.sh

bluetooth_hack() {
    while [ true ]
        do sudo pactl set-card-profile bluez_card.20_9B_A5_5B_B6_55 a2dp_sink
        sleep 1
    done
}

latex_watch ()
{
    inotifywait -m -e modify -r . |
      tee |
      grep --color=auto --line-buffered 'MODIFY .*.tex' | {
        while read line; do
            timeout 2 make;
        done
    }
}

which fuck 2>&1 >/dev/null && eval $(thefuck --alias oops)

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
then
    echo -e "${ANSI_GREEN}"
    figlet -f small "NVIM SUBSHELL"
    echo -e "${ANSI_NC}"

fi

# requires https://github.com/mhinz/neovim-remote
# install using pip3 install neovim-remote
getvim(){ [ -z "$NVIM_ACTIVE" ] && echo "nvim" || echo "nvr -cc vsp"; }

if [ -z "$NVIM_LISTEN_ADDRESS" ]
then
    export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
fi
export EDITOR="$(getvim)"
export HGEDITOR=$EDITOR

if [ ! -z "$NVIM_ACTIVE" ]
then
    export EDITOR="$EDITOR --remote-wait"
    export HGEDITOR="/bin/hgeditor.sh"
fi

# vim short cuts
alias vim='$(getvim)'
alias view='nvim -R'
alias sp='nvr -cc sp'
alias vs='nvr -cc vsp'
alias e='$(getvim)'

# Print out a random quote before yielding to the user
~/dotfiles/.quotes.py

tmux_status() {
    echo -ne "Running tmux sessions: \n\t\033[1;32m"
    tmux ls
    echo -ne "\033[0m"
}
tmux ls 2>/dev/null >/dev/null && tmux_status

VIM_SESSIONS=$(ls ~ | grep \.*vim$ | tr ' ' '\n')
if [ "$VIM_SESSIONS" != "" ]
then
  echo -ne "Saved vim sessions: \n\033[1;32m"
  ls ~ | grep \.*vim$ | sed 's/^/\t/'
  echo -ne "\033[0m"
fi


#TMUX_PROG='nvim -c "terminal"'
#[ "$TMUX" != "" ] && [ "$NVIM_ACTIVE" == "" ] && exec $TMUX_PROG
bind '"\e[1;5D" backward-word'
bind '"\e[1;5C" forward-word'

cat ~/.messages 2>/dev/null
