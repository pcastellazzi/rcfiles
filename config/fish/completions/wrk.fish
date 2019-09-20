if set -q WORKSPACE
  set w $WORKSPACE
else
  set w $HOME
end
complete -x -c wrk -a "(find $w/* -maxdepth 0 -type d | xargs -n1 basename)"
