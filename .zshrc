# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v  # vim keybindings
# End of lines configured by zsh-newuser-install

# Completion System
autoload -Uz compinit

# Don't pollute $HOME with zcompdump files, instead save here
compinit -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION-$HOST"

# Completion Style Configuration
zstyle :compinstall filename '$HOME/.zshrc'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive matching
zstyle ':completion:*' rehash true                       # automatically find new executables
zstyle ':completion:*' menu select                       # menu selection for completions

# Bash Completion Compatibility
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/mcli mcli

# Version Control Information Setup
autoload -Uz vcs_info
precmd() { vcs_info }

# Style for git in prompt
zstyle ':vcs_info:git:*' formats '%F{red}(branch: %b)%f '

# Prompt Configuration
setopt PROMPT_SUBST                    # allows for prompt expansion
PROMPT='%F{208}%n@%F{039}%M%f:%F{226}%~ %f${vcs_info_msg_0_}'

# Node Version Manager
source /usr/share/nvm/init-nvm.sh

# Start ssh-agent if not running already and load keys
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
    ssh-add ~/.ssh/github ~/.ssh/aur
fi

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

