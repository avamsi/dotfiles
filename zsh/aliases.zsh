alias ...='cd ../..'
alias ..='cd ..'
# https://github.com/wincent/clipper
alias clip='tee >(nc -N localhost 8377)'
alias grep='grep --color'
alias ll='ls -al'
# alias ls='ls --classify --color'
alias micro='tmicro'
alias re='grep -inrI'

_jj_color() {
	jj --color=always --config-toml='ui.relative-timestamps=true' $@
}

jjwatch() {
	tput civis
	while sleep 1; do
		# TODO: tmux clear-history as well?
		local header="$(clear)Every 1.0s: jj log && summary %-$(($(tput cols) - 59))s $(date)"
		local log="$(_jj_color log --reversed --revisions='remote_branches().. | parents(remote_branches()..)')"
		local pcc="| Parent commit changes:\n$(_jj_color diff --summary --revision=@- | indent)"
		local wcc="@ Working copy changes:\n$(_jj_color diff --summary --revision=@ | indent)"
		printf "$header\n\n$log\n\n$pcc\n\n$wcc"
	done
}

# Like cd, but for tmux sessions, creates a session if needed.
td() {
	local session=$1
	shift
	tmux new-session -s $session -d 2> /dev/null && {
		if [[ $# -ne 0 ]]; then
			tmux send-keys -t $session $@ C-m
		fi
	}
	tmux attach-session -t $session 2> /dev/null || tmux switch-client -t $session
}
