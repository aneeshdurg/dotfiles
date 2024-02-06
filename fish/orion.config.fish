# redshift shortcuts
alias rsx='redshift -x'
alias rson='redshift -O 3500'

function lszwin
    for pid in (xdotool search --class zoom)
        echo -n "$pid "
        xdotool getwindowname $pid
    end
end

set -gx PATH /home/aneesh/.cargo/bin/ $PATH
set -gx PATH /home/aneesh/.local/bin/ $PATH

alias n='ninja -C (git rev-parse --show-toplevel)/build'

#  _  __    _  _____  _    _   _    _       ____ ____      _    ____  _   _
# | |/ /   / \|_   _|/ \  | \ | |  / \     / ___|  _ \    / \  |  _ \| | | |
# | ' /   / _ \ | | / _ \ |  \| | / _ \   | |  _| |_) |  / _ \ | |_) | |_| |
# | . \  / ___ \| |/ ___ \| |\  |/ ___ \  | |_| |  _ <  / ___ \|  __/|  _  |
# |_|\_\/_/   \_\_/_/   \_\_| \_/_/   \_\  \____|_| \_\/_/   \_\_|   |_| |_|
#
# figlet: KATANA GRAPH
#
# function gethost
#   grep "\[1,"$argv[1]"\]" $argv[2]
# end
#
# function gettracefields
#   for arg in $argv
#     sed 's/^.* '$arg'=\([^ ]*\).*$/\1/'
#   end
# end
#
# function kp
#   set kpdir (git rev-parse --show-toplevel)
#   if [ "$CONDA_DEFAULT_ENV" = "katana-dev" ]
#     $kpdir/build/python_env.sh $argv
#   else
#     set_color red
#     echo "WARNING - running in wrong conda env, using `conda run`" >&2
#     set_color normal
#     conda run --live-stream --no-capture-output -n katana-dev $kpdir/build/python_env.sh $argv
#   end
# end
# set -x USE_GKE_GCLOUD_AUTH_PLUGIN True
# alias dev='/home/aneesh/katana-enterprise/scripts/dev'
# zoxide remove ~/google-cloud-sdk/
# set -x AWS_EC2_METADATA_DISABLED "true"
# # The next line updates PATH for the Google Cloud SDK.
# if [ -f '/home/aneesh/google-cloud-sdk/path.fish.inc' ]; . '/home/aneesh/google-cloud-sdk/path.fish.inc'; end

# set -x CONDA_LEFT_PROMPT "true"
# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# if test -f /home/aneesh/miniconda3/bin/conda
#     eval /home/aneesh/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# end
# # <<< conda initialize <<<


