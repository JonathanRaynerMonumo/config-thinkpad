# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v  # vim keybindings
# End of lines configured by zsh-newuser-install

autoload -Uz compinit

# Don't pollute $HOME with zcompdump files, instead save here
compinit -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION-$HOST"

# Completion Style Configuration
zstyle :compinstall filename '$HOME/.zshrc'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive matching
zstyle ':completion:*' rehash true                       # automatically find new executables
zstyle ':completion:*' menu select                       # menu selection for completions

# bash compatibility
autoload -U +X bashcompinit && bashcompinit

# prompt format
setopt PROMPT_SUBST
source "$HOME/git_repos/config/scm-prompt.sh"
PROMPT='%F{208}%n@%F{039}%M%F{226}:%~%F{red}$(_scm_prompt) '

# Prefer vim or else fail over to vi
EDITOR="$(command -v vim 2>/dev/null || command -v vi)"
VISUAL="$(command -v vim 2>/dev/null || command -v vi)"

# Node Version Manager
source /usr/share/nvm/init-nvm.sh


# Avoid stale environment variables (like for SSH forwarding) when rejoing tmux sessions
function update_env_in_tmux() {
	if [ -n "${TMUX}" ]; then
		eval "$(tmux show-environment -s)"
	fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd update_env_in_tmux

# Plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# minio client
complete -o nospace -C /usr/bin/mcli mcli

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

# ssh
# start ssh-agent if not running already and load keys
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
