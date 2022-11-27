autoload -Uz select-word-style
select-word-style bash

bindkey '^[[1;5D' backward-word  # ctrl-left
bindkey '^[[1;5C' forward-word  # ctrl-right

autoload -Uz edit-command-line
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
