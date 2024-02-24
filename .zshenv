# Prefer vim or else fail over to vi
export EDITOR="$(command -v vim 2>/dev/null || command -v vi)"
export VISUAL="$(command -v vim 2>/dev/null || command -v vi)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
