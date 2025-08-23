(( ${+commands[fzf]} )) && source <(fzf --zsh)

export FZF_DEFAULT_OPTS='
--color="fg:242,hl:65,fg+:15,bg+:239,hl+:108"
--color="info:108,prompt:109,spinner:108,pointer:168,marker:168"'
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
		--ansi \
		--preview='jj bgc show --summary {1}' \
		--preview-window="~2:wrap" \
		-- "$@" < <(
			jj bgc list --revisions=interesting --template='oneline(self)'
		)
}

_fzf_complete_jj_post() {
	cut -d ' ' -f1
}
