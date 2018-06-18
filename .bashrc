alias iman='~/.man.sh'
#eval $(thefuck --alias oops)

# requires https://github.com/mhinz/neovim-remote
getvim(){ [ -z "$NVIM_ACTIVE" ] && echo "nvim" || echo "nvr -cc vsp"; }
alias rsx='redshift -x'
alias rson='redshift -O 3500'
alias vim='$(getvim)'
alias view='nvim -R'
alias ldc='ldc2'
alias react-native='/usr/bin/nodejs8/bin/react-native'
alias create-react-native='/usr/bin/nodejs8/bin/create-react-native'
alias wu-tang='~/dotfiles/wu-tang.sh'

export GOPATH=/usr/share/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export ANDROID_HOME=/home/aneesh/Android/Sdk/

source ~/dotfiles/z/z.sh
source ~/dotfiles/vimedit.sh

export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
~/dotfiles/.quotes.py

print_all_colors() {
    for x in {30..37}
    do 
        for y in {1..2}
            do echo -ne "\033[${y};${x}m█\033[0m"
        done
    done
    echo ""
}
