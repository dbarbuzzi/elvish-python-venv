use path
use re
use str

var prev = [&paths=$nil &pythonhome=$nil]

fn is-venv {
  |path|
  try {
    # a venv will have pyvenv.cfg
    nop (path:abs (path:eval-symlinks (path:join $path pyvenv.cfg)))
  } catch exc {
    # pyvenv.cfg not found, not a venv
    put $false
  } else {
    put $true
  }
}

fn pretty-path {
  |path|
  # Prepend . if in working directory
  set path = (re:replace '^./' '' $path)
  # Replace working directory with .
  set path = (re:replace '^'(re:quote (pwd))'/' './' $path)
  # Replace HOME with ~
  put (re:replace '^'(re:quote $E:HOME)'/' '~/' $path)
}

fn deactivate {
  if (eq $E:VIRTUAL_ENV '') {
    echo 'venv: not activated' >&2
    return
  }

  if (not-eq $prev[paths] $nil) {
    set paths = $prev[paths]
    set prev[paths] = $nil
  }

  if (not-eq $prev[pythonhome] $nil) {
    set-env PYTHONHOME = $prev[pythonhome]
    set prev[pythonhome] = $nil
  }

  var venv = (get-env VIRTUAL_ENV)
  unset-env VIRTUAL_ENV
  echo 'venv: deactivated: '(pretty-path $venv) >&2
}

fn activate {
  |venv|
  if (eq $venv '') {
    fail 'usage: venv:activate <path/to/venv>'
  }
  if (not (is-venv $venv)) {
    fail 'venv: not a venv: '$venv
  }
  if (not-eq $E:VIRTUAL_ENV '') {
    deactivate
  }
  set venv = (path:abs $venv)
  set-env VIRTUAL_ENV $venv
  set prev[paths] = $paths
  set paths = [(path:join $venv bin) $@paths]

  if (not-eq $E:PYTHONHOME '') {
    set prev[pythonhome] = (get-env PYTHONHOME)
    unset-env PYTHONHOME
  }
  echo 'venv: activated '(pretty-path $venv) >&2
}

set edit:completion:arg-completer[venv:activate] = {
  |@args|
  if (> (count $args) (num 2)) {
    # only complete first argument after 'py:activate'
    return
  }

  # recursively look for venvs in current directory up to 2 levels deep
  find . -maxdepth 3 -name pyvenv.cfg | each {|cfg|
    put (pretty-path (path:dir $cfg))
  }
}
