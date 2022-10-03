# elvish-python-venv
Elvish module to activate/deactivate Python virtualenvs &amp; venvs

## installation

```
use epm
epm:install github.com/elijahr/elvish-python-venv
```

Then put this in `~/.config/elvish/rc.elv`:

```
# setup aliases for working with Python virtual environments
use github.com/elijahr/elvish-python-venv/venv
var venv~ = venv:activate~
var activate~ = venv:activate~
var deactivate~ = venv:deactivate~
set edit:completion:arg-completer[venv] =
set edit:completion:arg-completer[activate] = $edit:completion:arg-completer[venv:activate]
```

## example usage

create a venv or virtualenv

```shell
python -m venv .venv
```

activate the venv

```
❯ which python
/opt/homebrew/bin/python

❯ activate ./my-env
venv: activated ./my-env

❯ which python
/Users/me/project/venv/bin/python

... install packages, run scripts, etc
```

deactivate the venv

```
❯ deactivate
venv: deactivated: ./venv

❯ which python
/opt/homebrew/bin/python3
```
