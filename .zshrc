# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export DISPLAY=':0'
export EDITOR='micro'
export TERM='xterm-256color'

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/miniconda3/bin:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"

autoload -Uz select-word-style
select-word-style bash

bindkey '^[[1;5D' backward-word  # ctrl-left
bindkey '^[[1;5C' forward-word  # ctrl-right

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line  # ctrl-x, ctrl-e

up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history

down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

bindkey '^[[A' up-line-or-local-history  # up
bindkey '^[[B' down-line-or-local-history  # down

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh/history.zsh

autoload -Uz compinit
compinit

autoload -Uz promptinit
promptinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/zsh_cache

source ~/.zsh/aliases.zsh
source ~/.zsh/options.zsh

source ~/.zsh/almostontop/almostontop.plugin.zsh
source /usr/local/share/antigen/antigen.zsh
antigen theme romkatv/powerlevel10k
antigen bundle Aloxaf/fzf-tab
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='
--color fg:242,hl:65,fg+:15,bg+:239,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168'
# Preview can be hidden by default by adding :hidden to the preview-window.
export FZF_CTRL_R_OPTS='
--height=80%
--preview="echo {}"
--preview-window="down:5:wrap"
--bind="?:toggle-preview"'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
