maketex() {
  echo -e "all: $1.pdf\n\n$1.pdf: $1.tex\n\tpdflatex $1.tex" | 
    timeout 2 make -f /dev/stdin
}

_vimedit(){
  while [ true ];
  do 
    maketex $1
    sleep 2;
  done;
}

vimedit() { 
  touch $1.tex
  maketex $1
  xdg-open $1.pdf
  _vimedit $1 > /dev/null 2>err_log & 
  vim $1.tex 
}

export vimedit
