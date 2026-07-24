# ---- Tmux auto-start ----
if [[ -o interactive && -z $TMUX && -z $SSH_CONNECTION ]] && (( $+commands[tmux] )); then
    exec tmux new-session -A -s main
fi

# ---- Powerlevel10k instant prompt (must stay near the top) ----
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---- Plugin manager (zinit) ----
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -r "$ZINIT_HOME/zinit.zsh" ]]; then
  print -u2 "zinit is missing: $ZINIT_HOME"
  return
fi
source "$ZINIT_HOME/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting

autoload -Uz compinit && compinit
zinit cdreplay -q

# ---- Environment ----
export EDITOR=nvim
export VISUAL=nvim

# ---- History ----
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_find_no_dups

# ---- Aliases ----
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

# ---- Functions ----
# yazi: cd to the last visited directory on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --show-hidden --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ---- Completion styling ----
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ---- Shell integrations ----
(( $+commands[fzf] )) && eval "$(fzf --zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init --cmd cd zsh)"

# ---- PATH (ordered, deduped, no machine-specific leftovers) ----
typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/.npm-global/bin" $path)
path=("${(@)path:#/home/lbc/.local/share/gem/ruby/3.4.0/bin}")

# ---- Prompt ----
# Run `p10k configure` or edit ~/.p10k.zsh to customize.
(( $+functions[p10k] )) && [[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
