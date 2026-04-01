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

function run_in_ns
  set pid (docker inspect $argv[1] | jq \.[0].State.Pid)
  set argv $argv[2..-1]
  set flag "-n"
  switch $argv[1]
  case "-*"
    set flag $argv[1]
    set argv $argv[2..-1]
  end
  eval sudo nsenter -t $pid $flag '$argv'
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/aneesh/miniforge3/bin/conda
    eval /home/aneesh/miniforge3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/aneesh/miniforge3/etc/fish/conf.d/conda.fish"
        . "/home/aneesh/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/aneesh/miniforge3/bin" $PATH
    end
end
# <<< conda initialize <<<

