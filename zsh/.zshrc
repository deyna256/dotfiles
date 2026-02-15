# Auto-start tmux before anything else
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [ -z "$TMUX" ]; then
    exec tmux new-session -A -s default
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
alias ls='ls -a --color'
alias c='clear'
alias lg='lazygit'
alias ld='lazydocker'
alias lssh='lazyssh'
alias grep='rg'
alias find='fd'
alias f='fd'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# Yazi wrapper function to change directory on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --show-hidden --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Envs
export TERM=xterm-256color
export PATH="$PATH:/home/lbc/.local/share/gem/ruby/3.4.0/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH=~/.npm-global/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"


# SSH Agent
  if [ -z "$SSH_AUTH_SOCK" ]; then
     eval "$(ssh-agent -s)" > /dev/null
     ssh-add ~/.ssh/github/github 2>/dev/null
  fi

# Claude Code with OpenRouter
#export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
#export ANTHROPIC_AUTH_TOKEN="sk-or-v1..."
#export ANTHROPIC_API_KEY=""
#export ANTHROPIC_DEFAULT_SONNET_MODEL="minimax/minimax-m2.1"
#export ANTHROPIC_DEFAULT_HAIKU_MODEL="moonshotai/kimi-k2.5"
#export ANTHROPIC_DEFAULT_OPUS_MODEL="x-ai/grok-code-fast-1"
