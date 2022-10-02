# elvish-python-venv
Elvish module to activate/deactivate Python virtualenvs &amp; venvs

## installation

```
use epm
epm:install github.com/elijahr/elvish-python-venv
```

Then put this in `~/.config/elvish/rc.elv`:

```
fn activate {|name| venv:activate $name }
set edit:completion:arg-completer[activate] = $edit:completion:arg-completer[venv:activate]
fn deactivate { venv:deactivate }
```

## usage

create a venv or virtualenv

```shell
python -m my-venv
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
