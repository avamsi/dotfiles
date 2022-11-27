# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export DISPLAY=':0'
export EDITOR='tmicro'
export TERM='xterm-256color'

export PATH="$HOME/dotfiles/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

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

# github.com/avamsi/heimdall
source <(heimdall sh)

source ~/dotfiles/zsh/aliases.zsh
source ~/dotfiles/zsh/options.zsh

source ~/.zsh/almostontop/almostontop.plugin.zsh
source /usr/local/share/antigen/antigen.zsh
antigen theme romkatv/powerlevel10k
antigen bundle Aloxaf/fzf-tab
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
antigen bundle zdharma-continuum/fast-syntax-highlighting
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
# Use fzf with tmux popup to always show a large enough selection window no
# matter the size of tmux pane on which fzf was triggered.
export FZF_TMUX=1
export FZF_TMUX_OPTS='-p 80%'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
