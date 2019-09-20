function wrk --description 'cd into my workspace or a project' --argument project
  if set -q WORKSPACE
    set w $WORKSPACE
  else
    set w $HOME
  end

  if test -n "$project"
    set w $w/$project
  end

  if test -d $w
    cd $w
  else
    echo >&2 "Not a valid dir: $w"
    return 1
  end
end
