
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
