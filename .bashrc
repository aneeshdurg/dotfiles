set -o vi

export ANSI_BLUE="\033[0;34m"
export ANSI_YELLOW="\033[0;33m"
export ANSI_GREEN="\033[0;32m"
export ANSI_RED="\033[0;31m"
export ANSI_NC="\033[0m"
print_all_colors() {
    for x in {30..37}
    do
        for y in {1..2}
            do echo -ne "\033[${y};${x}m█\033[0m"
        done
    done
    echo ""
}

# requires https://github.com/mhinz/neovim-remote
# install using pip3 install neovim-remote
getvim(){ [ -z "$NVIM_ACTIVE" ] && echo "nvim" || echo "nvr --nostart -cc vsp"; }
if [ ! -z "$NVIM_ACTIVE" ]
then
    echo -e "${ANSI_GREEN}"
    figlet -f small "NVIM SUBSHELL"
    echo -e "${ANSI_NC}"

fi
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
export EDITOR="$(getvim)"
if [ ! -z "$NVIM_ACTIVE" ]
then
    export EDITOR="$EDITOR --remote-wait"
fi
export HGEDITOR=$EDITOR
# :(){ nvr -cc "$@"; };

# redshift shortcuts
alias rsx='redshift -x'
alias rson='redshift -O 3500'
# compilers/frameworks
alias ldc='ldc2'
alias react-native='/usr/bin/nodejs8/bin/react-native'
alias create-react-native='/usr/bin/nodejs8/bin/create-react-native'
# lol
alias wu-tang='~/dotfiles/wu-tang.sh'
# vim short cuts
alias vim='$(getvim)'
alias view='nvim -R'
alias sp='nvr -cc sp'
alias vs='nvr -cc vsp'
alias e='$(getvim)'

# Path extensions
export GOPATH=/usr/share/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export ANDROID_HOME=/home/aneesh/Android/Sdk/

source ~/dotfiles/z/z.sh
source ~/dotfiles/vimedit.sh

# Print quote
~/dotfiles/.quotes.py
