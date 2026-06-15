# ~/.zshrc


# EXPORT
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="xterm-256color"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export EDITOR="micro"
export GPG_TTY=$TTY


# PATH
export PATH="${HOME}/.local/bin:${PATH}"


# TMUX
[[ -n "$SSH_CONNECTION" ]] && [[ -z "$TMUX" ]] && exec tmux new-session -As main


# HISTORY
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY APPEND_HISTORY HIST_FIND_NO_DUPS

# COMPLETIONS
autoload -Uz compinit && compinit -C -d "${XDG_CACHE_HOME}/.zcompdump"
zmodload -i zsh/complist
setopt auto_menu complete_in_word always_to_end
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/.zcompcache"


# PLUGINS
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
[[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh ]] \
  && source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh


# KEYBINDINGS
bindkey -e
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word


# FZF
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# ZOXIDE
eval "$(zoxide init --cmd cd zsh)"

# ALIASES
alias ls='eza --icons --color=auto --group-directories-first'
alias ll='eza --icons --color=auto --group-directories-first -la --git'
alias la='eza --icons --color=auto -la'
alias l1='eza -1 --icons=never'

alias cat='bat'
alias nano='micro'
alias find='fd'
alias preview='fzf --preview="bat --color=always {}"'

alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias df='df -h'
alias du='du -h'
alias grep='grep --color=auto'


# FUNCTIONS

function cd() {
  builtin cd "${@:-$HOME}" 2>/dev/null || return 1
  local count=$(command ls | wc -l | tr -d ' ')
  if [[ $count -gt 20 ]]; then
    eza --icons --color=auto --group-directories-first -la --git | head -20
    print "  ... e altri $((count - 20)) file (tot: $count)"
  else
    eza --icons --color=auto --group-directories-first -la --git
  fi
}

function extract() {
  if [[ ! -f "$1" ]]; then echo "'$1' is not a valid file"; return 1; fi
  case "$1" in
    *.tar.bz2) tar xjvf "$1" ;; *.tar.gz)  tar xzvf "$1" ;;
    *.tar.xz)  tar xvf  "$1" ;; *.tar)     tar xf   "$1" ;;
    *.bz2)     bzip2 -d "$1" ;; *.gz)      gunzip   "$1" ;;
    *.rar)     unrar x  "$1" ;; *.zip)     unzip    "$1" ;;
    *.7z)      7z x     "$1" ;; *.Z)       uncompress "$1" ;;
    *.tbz2)    tar xjf  "$1" ;; *.tgz)     tar xzf  "$1" ;;
    *) echo "'$1' cannot be extracted" ;;
  esac
}

# STARSHIP
eval "$(starship init zsh)"

# OS-SPECIFIC
if [[ "$(uname)" == "Darwin" ]]; then
   export PATH="/opt/homebrew/bin:$PATH"
   export PATH="/opt/homebrew/sbin:$PATH"
elif [[ "$(uname)" == "Linux" ]]; then
fi


