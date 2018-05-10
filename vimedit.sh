maketex() {
  echo -e "all: $1.pdf\n\n$1.pdf: $1.tex\n\tpdflatex $1.tex" | 
    timeout 2 make -f /dev/stdin
}

_vimedit(){
  while [ true ]
  do 
    if ps -p $1 > /dev/null
    then
      maketex $3
      sleep 2;
    else
      kill $2
      break
    fi
  done
}

vimedit() { 
  touch $1.tex
  maketex $1
  ps > /tmp/vimedit_ps1
  xdg-open $1.pdf;
  ps > /tmp/vimedit_ps2
  viewerpid=$(diff /tmp/vimedit_ps1 /tmp/vimedit_ps2 | grep -v "ps" | tail -1 | cut -d\  -f2)
  rm /tmp/vimedit_ps1 /tmp/vimedit_ps2
  vim $1.tex &
  jid=$(jobs -l | cut -d[ -f2 | cut -d] -f1)
  pid=$(jobs -l | cut -d\  -f2)
  _vimedit $pid $viewerpid $1 > /dev/null 2>err_log & 
  fg $jid
}

export vimedit
