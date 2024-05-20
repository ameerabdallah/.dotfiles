# If you come from bash you might have to change your $PATH.
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export NVIM_CONF="$XDG_CONFIG_HOME/nvim"

# Maybe will add later
# ZINIT_HOME="${XDG_CONFIG_HOME:-${HOME}/.local/share}/zinit/zinit.git"
#
# if [[ ! -d $ZINIT_HOME ]]; then
#     mkdir -p $ZINIT_HOME
#     git clone https://github.com/zdharma/zinit.git "$ZINIT_HOME"
# fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"

export SHELL=/bin/zsh
export EDITOR='nvim'

# User configuration
source ~/.profile
if [[ -n "$TMUX" ]]; then
    export TERM=screen-256color
else
    export TERM=xterm-256color
fi

eval $(thefuck --alias)
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# set theme for oh-my-zsh
ZSH_THEME="ameer"

# _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# PLUGINS
plugins=(
    git 
    zsh-autosuggestions
    zsh-syntax-highlighting 
    colored-man-pages 
    thefuck
    nvm
)

# lazy load nvm for faster startup
zstyle ':omz:plugins:nvm' lazy yes

source $ZSH/oh-my-zsh.sh

source ~/.zsh_aliases
bindkey '^j' autosuggest-accept

# Start ssh-agent if not already running
if ! pgrep -U "$(id -u)" ssh-agent > /dev/null; then
    ssh-agent -s > "${HOME}/.ssh-agent-info"
fi

# Load ssh-agent information
if [[ -f "${HOME}/.ssh-agent-info" ]]; then
    source "${HOME}/.ssh-agent-info" > /dev/null
fi

export FPATH="${HOME}/.dotfiles/completions/:$FPATH"
