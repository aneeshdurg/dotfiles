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

alias co="COPILOT_PROVIDER_MAX_PROMPT_TOKENS=100000 COPILOT_PROVIDER_MAX_OUTPUT_TOKENS=(math \"196608-100000\") ollama launch copilot --model odytrice/qwen3.8:4090-27b"

# copilot against a local `ft serve` instance instead of ollama
function co-ft
  env COPILOT_PROVIDER_BASE_URL=http://127.0.0.1:1919/v1 \
    COPILOT_MODEL=ft-serve \
    copilot $argv
    # COPILOT_PROVIDER_MAX_PROMPT_TOKENS=100000 \
    # COPILOT_PROVIDER_MAX_OUTPUT_TOKENS=(math "196608-100000") \
end

# copilot against a local Bonsai-demo llama-server (bonsai2, native tool_calls
# via --jinja). Starts the server if it isn't already running, and stops it
# again on exit (unless it was already running before this was called).

function co-bonsai
  if not set -q REASONING_BUDGET
      set -g REASONING_BUDGET 2048
  end

  set -l bonsai_script /home/aneesh/Bonsai-demo/scripts/start_llama_server.sh
  set -l port 8080
  set -l server_pid

  if not curl -s --max-time 1 http://127.0.0.1:$port/health >/dev/null 2>&1
    $bonsai_script  --reasoning-budget $REASONING_BUDGET >/tmp/bonsai-server.log 2>&1 &
    set server_pid $last_pid
    echo "Starting Bonsai llama-server (pid $server_pid, log: /tmp/bonsai-server.log)..."
    while not curl -s --max-time 1 http://127.0.0.1:$port/health >/dev/null 2>&1
      sleep 1
    end
  end

  env COPILOT_PROVIDER_BASE_URL=http://127.0.0.1:$port/v1 \
    COPILOT_MODEL=bonsai2 \
    copilot $argv

  if set -q server_pid[1]
    kill $server_pid
  end
end

# cline against a local Bonsai-demo llama-server (bonsai2, native tool_calls
# via --jinja). Starts the server if it isn't already running, and stops it
# again on exit (unless it was already running before this was called).
function cline-bonsai
  if not set -q REASONING_BUDGET
      set -g REASONING_BUDGET 2048
  end

  set -l bonsai_script /home/aneesh/Bonsai-demo/scripts/start_llama_server.sh
  set -l port 8080
  set -l server_pid

  if not curl -s --max-time 1 http://127.0.0.1:$port/health >/dev/null 2>&1
    $bonsai_script  --reasoning-budget $REASONING_BUDGET >/tmp/bonsai-server.log 2>&1 &
    set server_pid $last_pid
    echo "Starting Bonsai llama-server (pid $server_pid, log: /tmp/bonsai-server.log)..."
    while not curl -s --max-time 1 http://127.0.0.1:$port/health >/dev/null 2>&1
      sleep 1
    end
  end

  cline auth -p openai-compatible -b http://127.0.0.1:$port/v1 -m bonsai2 -k dummy >/dev/null

  cline -P openai-compatible -m bonsai2 $argv

  if set -q server_pid[1]
    kill $server_pid
  end
end

# cline against a local llama-server serving ukisai/Swift-Qwen3.8-27B-GGUF.
# Starts the server if it isn't already running, and stops it again on exit
# (unless it was already running before this was called). Uses port 8081 so
# it doesn't collide with cline-bonsai's server (which defaults to 8080).
function cline-swift
  set -l model swift2
  set -l port 8081
  set -l server_pid

  if not curl -s --max-time 1 http://127.0.0.1:$port/health >/dev/null 2>&1
    ~/Bonsai-demo/bin/cuda/llama-server -hf ukisai/Swift-Qwen3.8-27B-GGUF:Q4_K_M \
      -c 32768 -ngl 99 --flash-attn on --port $port >/tmp/swift-server.log 2>&1 &
    set server_pid $last_pid
    echo "Starting Swift-Qwen3 llama-server (pid $server_pid, log: /tmp/swift-server.log)..."
    while not curl -s --max-time 1 http://127.0.0.1:$port/health >/dev/null 2>&1
      sleep 1
    end
  end

  cline auth -p openai-compatible -b http://127.0.0.1:$port/v1 -m $model -k dummy >/dev/null

  cline -P openai-compatible -m $model $argv

  if set -q server_pid[1]
    kill $server_pid
  end
end

# Open files in fileserver
if set -q SSH_CLIENT
  function xdg-open
    set -l cmd
    for arg in $argv
      set -l path (realpath --relative-to ~ $arg)
      set cmd $cmd "DISPLAY=:0 firefox localhost:8000/$path;"
    end
    ssh pluto -t "$cmd"
  end
end
