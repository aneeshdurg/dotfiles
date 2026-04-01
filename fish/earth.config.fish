set -gx PATH /home/aneesh/.dprint/bin/ $PATH
set -gx PATH /home/aneesh/.local/bin/ $PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/aneesh/mambaforge/bin/conda
  eval /Users/aneesh/mambaforge/bin/conda "shell.fish" "hook" $argv | source
end
if test -f /home/aneesh/miniconda3/bin/conda
  eval /home/aneesh/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end

# <<< conda initialize <<<

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

alias cor='ca corvic; poetry env use python3.12 && source (poetry env info --path)/bin/activate.fish'

# pnpm
set -gx PNPM_HOME "/home/aneesh/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# aider
set -gx OLLAMA_API_BASE http://127.0.0.1:11434

# corvic
function corkill
  ps aux | grep corvic.cloud_cli | grep -v grep | awk "{print \$2}" | xargs -n 1 -- kill -9
  ps aux | grep uvicorn | grep corvic/python/corvic_test/ingest | grep -v grep | awk "{print \$2}" | xargs -n 1 -- kill -9
end

function correset
  rm -rf ~/storage-dir
  mkdir ~/storage-dir
end

function pparquet

  python -c "\
import glob
import polars as pl
for f in glob.glob(\"*.parquet\"):
  print(f)
  print(pl.read_parquet(f))
  print()
"

end

# source ~/.asdf/asdf.fish
alias asterdock="docker run -it --privileged --network=host --device=/dev/kvm -v (pwd)/:/root/asterinas ldosproject/asterinas:0.15.2-20250613"
