# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v  # vim keybindings
# End of lines configured by zsh-newuser-install

autoload -Uz compinit

# where is our config repo
CONFIG_REPO="$HOME/git-repos/config"

# add any custom zsh completions from our chosen dir before compinit
fpath=("$CONFIG_REPO/zsh_custom_completions" $fpath)

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
# git repo prompt stuff
autoload -Uz vcs_info
precmd() { vcs_info }
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%F{red}(branch: %b)%f '

setopt PROMPT_SUBST
source "$CONFIG_REPO/jj-prompt.sh"

# Fallback to Git if jj unavailable
_my_theme_vcs_info() {
  # Get the jj info
  local jj_info=$(jj_prompt_template 'self.change_id().shortest()' 2>/dev/null)
  
  # If jj info exists, format it with brackets and 1 space
  if [[ -n "$jj_info" ]]; then
    echo "(${jj_info}) "
  else
    # Fallback to Git branch info
    echo "${vcs_info_msg_0_}"
  fi
}

PROMPT='%F{208}%n@%F{039}%M%F{226}:%~%F{red} $(_my_theme_vcs_info)'
#PROMPT='%F{208}%n@%F{039}%M%F{226}:%~%F{red} ${vcs_info_msg_0_}'

# Prefer vim or else fail over to vi
export EDITOR="$(command -v vim 2>/dev/null || command -v vi)"
export VISUAL="$(command -v vim 2>/dev/null || command -v vi)"

# Avoid stale environment variables (like for SSH forwarding) when rejoing tmux sessions
function update_env_in_tmux() {
	if [ -n "${TMUX}" ]; then
		eval "$(tmux show-environment -s)"
	fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd update_env_in_tmux

# Plugins
source /home/jonathan/git-repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# rust/cargo stuff
PATH="$HOME/.cargo/bin:${PATH}"

# jujutsu completions
source <(jj util completion zsh)


. "$HOME/.cargo/env"
