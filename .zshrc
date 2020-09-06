stty -ixon

export DISPLAY=":0"
export TERM='xterm-256color'

bindkey -e

autoload -Uz select-word-style
select-word-style bash
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh/history.zsh

autoload -Uz compinit
compinit

autoload -Uz promptinit
promptinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/zsh_cache

PROMPT='
%F{white}[%M @ %F{226}%*%f]:[%~]%f
%F{068}$%f '

source ~/.zsh/aliases.zsh
source ~/.zsh/options.zsh

source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='
--color fg:242,hl:65,fg+:15,bg+:239,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168'

source ~/.zsh/almostontop/almostontop.plugin.zsh
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_USE_ASYNC='true'

source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
