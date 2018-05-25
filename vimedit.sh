maketex() {
  # Compile input from stdin to dynamically generate makefile
  echo -e "all: $1.pdf\n\n$1.pdf: $1.tex\n\tpdflatex $1.tex" | 
    timeout 2 make -f /dev/stdin
}

_vimedit(){
  echo "PS COMMAND: ps -p $1"
  echo "$1 $2 $3"
  while [ true ]
  do 
    # If vim is still running
    if ps -p $1 > /dev/null
    then
      maketex $3
      sleep 2;
    else
      # Stop pdf viewer and exit
      kill $2
      break
    fi
  done
}

vimedit() { 
  # make sure source file exists and generate pdf
  touch $1.tex
  maketex $1 

  # Start pdf viewer and get pid by checking ps before and after xdg-open
  ps > /tmp/vimedit_ps1
  xdg-open $1.pdf;
  ps > /tmp/vimedit_ps2
  viewerpid=$(diff /tmp/vimedit_ps1 /tmp/vimedit_ps2 | grep -v "ps" | tail -1 | cut -d\  -f2)
  rm /tmp/vimedit_ps1 /tmp/vimedit_ps2

  # Start editing source in background
  vim $1.tex &

  # Get jobid and processid of vim
  jid=$(jobs -l | tail -1 | cut -d[ -f2 | cut -d] -f1)
  pid=$(jobs -l | tail -1 | cut -d\  -f2)

  # Start compiling latex in background
  _vimedit $pid $viewerpid $1 >/dev/null 2>err_log & 

  # Foreground vim
  fg $jid
}

export vimedit
