
set -gx PATH /home/aneesh/.local/bin/ $PATH
source ~/.asdf/asdf.fish

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

function killgatherdata
  for pid in  (ps aux | grep 'bash gatherdata' | awk '{print $2}')
    kill $pid
  end
end

function mvcurrent
  mv $argv ~/pando/current/
end

alias cor='ca corvic; poetry env use python3.11 && source (poetry env info --path)/bin/activate.fish'

# pnpm
set -gx PNPM_HOME "/home/aneesh/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
