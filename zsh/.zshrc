# ---- Tmux auto-start ----
if [[ -o interactive && -z $TMUX ]] && (( $+commands[tmux] )); then
    exec tmux new-session -A -s main
fi

# ---- Powerlevel10k instant prompt (must stay near the top) ----
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---- Keys ----
# Without this zsh picks the keymap from $EDITOR, and "nvim" contains "vi",
# so it silently lands in vi mode.
bindkey -e

# Home/End/Delete are unbound by default. Both the legacy and the modern
# escape sequences are bound, since terminals disagree on which they send.
bindkey '^[[H'    beginning-of-line
bindkey '^[[1~'   beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^[[4~'   end-of-line
bindkey '^[[3~'   delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ---- Plugins ----
# zinit installs and updates plugins, but loading it costs ~87ms per shell, so
# the plugins are sourced straight from disk instead. Run `zi update --all` to
# pull zinit in on demand and refresh them.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
ZINIT_PLUGINS="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/plugins"
zi() { source "$ZINIT_HOME/zinit.zsh" && zinit "$@" }

# Bytecode-compile a file when the source is newer, then source it. Saves zsh
# re-parsing ~90KB of .p10k.zsh and the plugin sources on every start.
_zsrc() {
  [[ -r $1 ]] || return
  [[ -s $1.zwc && $1.zwc -nt $1 ]] || zcompile -R -- $1.zwc $1 2>/dev/null
  source $1
}

_compinit_cached() {
  setopt local_options extendedglob
  autoload -Uz compinit
  local dump=${ZDOTDIR:-$HOME}/.zcompdump
  if [[ -n $dump(#qN.mh-24) ]]; then compinit -C -d $dump; else compinit -d $dump; fi
}

_zsrc $ZINIT_PLUGINS/romkatv---powerlevel10k/powerlevel10k.zsh-theme

# Rebinding every ZLE widget on each precmd costs ~15ms per prompt. Bind once
# instead, which requires autosuggestions to load last, after every other
# widget-wrapping plugin. Adding such a plugin means calling
# _zsh_autosuggest_bind_widgets by hand.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

fpath=($ZINIT_PLUGINS/zsh-users---zsh-completions/src $fpath)
_compinit_cached
_zsrc $ZINIT_PLUGINS/Aloxaf---fzf-tab/fzf-tab.plugin.zsh
_zsrc $ZINIT_PLUGINS/zdharma-continuum---fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
_zsrc $ZINIT_PLUGINS/zsh-users---zsh-autosuggestions/zsh-autosuggestions.zsh

# ---- Environment ----
setopt interactive_comments
export EDITOR=nvim
export VISUAL=nvim

# ---- History ----
HISTFILE=~/.zsh_history
HISTSIZE=100000          # keep more in memory than on disk, so dedup has room
SAVEHIST=50000
# share_history already implies incremental append; extended_history adds
# timestamps, without which "when did I run this" is unanswerable.
setopt share_history extended_history hist_expire_dups_first
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_find_no_dups

# ---- Aliases ----
alias ls='ls -A --color=auto'
alias c='clear'
alias lg='lazygit'
alias ld='lazydocker'
alias lssh='lazyssh'
alias f='fd'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# ---- Functions ----
# yazi: cd to the last visited directory on exit
y() {
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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color=always $realpath'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# ---- Shell integrations ----
# These init scripts are static; regenerating them costs a process spawn per
# shell. Cache to disk, refresh only when the binary itself is newer.
_cached_eval() {  # _cached_eval <name> <binary> <command...>
  local name=$1 bin=$2; shift 2
  (( $+commands[$bin] )) || return
  local c=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/$name.zsh
  if [[ ! -s $c || $commands[$bin] -nt $c ]]; then
    mkdir -p $c:h && "$@" > $c
  fi
  _zsrc $c
}
_cached_eval dircolors dircolors dircolors -b
_cached_eval fzf    fzf    fzf --zsh
_cached_eval zoxide zoxide zoxide init --cmd cd zsh

# ---- PATH (ordered, deduped, no machine-specific leftovers) ----
typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/.npm-global/bin" $path)

# ---- Prompt ----
# Run `p10k configure` or edit ~/.p10k.zsh to customize.
(( $+functions[p10k] )) && _zsrc ~/.p10k.zsh
