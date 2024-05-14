# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

export DISPLAY=':0'
export EDITOR='tmicro'
export TERM='xterm-256color'

export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"
export PATH="${GOPATH:-$HOME/go}/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE

autoload -Uz compinit
compinit

source ~/dotfiles/zsh/aliases.zsh
source ~/dotfiles/zsh/keys.zsh
source ~/dotfiles/zsh/options.zsh
source ~/dotfiles/zsh/plugins.zsh

# https://github.com/martinvonz/jj
(( ${+commands[jj]} )) && source <(jj util completion zsh)

# https://github.com/avamsi/axl
(( ${+commands[axl]} )) && source <(axl hooks zsh)
# export AXL_NOTIFY=...

(( ${+commands[fzf]} )) && source <(fzf --zsh)

export FZF_DEFAULT_OPTS='
--color fg:242,hl:65,fg+:15,bg+:239,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168'
# Preview can be hidden by default by adding :hidden to the preview-window.
# print: -r to print raw string and -n to not print newline.
export FZF_CTRL_R_OPTS='
--height=80%
--preview="print -rn {}"
--preview-window="down:5:wrap"
--bind="?:toggle-preview"'
# Use fzf with tmux popup to always show a large enough selection window no
# matter the size of tmux pane on which fzf was triggered.
export FZF_TMUX=1
export FZF_TMUX_OPTS='-p 80%'

export FZF_COMPLETION_TRIGGER='`'

_fzf_complete_jj() {
	_fzf_complete \
		--preview 'jj bgc show --summary {1}' \
		--preview-window wrap -- "$@" < <(
			jj bg list --revisions=interesting --template=oneline
		)
}

_fzf_complete_jj_post() {
	cut -d ' ' -f1
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
