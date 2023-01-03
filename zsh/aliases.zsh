alias ...='cd ../..'
alias ..='cd ..'
# https://github.com/wincent/clipper
alias clip='tee >(nc -N localhost 8377)'
alias grep='grep --color'
alias ll='ls -al'
# alias ls='ls --classify --color'
alias micro='tmicro'
alias re='grep -inrI'

jjwatch() {
	tput civis
	local header
	while sleep 1; do
		# TODO: tmux clear-history as well?
		header="$(clear)Every 1.0s: jj log && summary %-$(($(tput cols) - 59))s $(date)"
		log=$(jj --color=always log --reversed)
		reset='\e[0m'
		pcc="| Parent commit changes:\n$(jj --color=always show --summary @- | tail -n +7 | indent)$reset"
		wcc="@ Working copy changes:\n$(jj --color=always show --summary @ | tail -n +7 | indent)$reset"
		printf "$header\n\n$log\n\n$pcc\n\n$wcc"
	done
}

# Like cd, but for tmux sessions, creates a session if needed.
td() {
	local session
	session=$1
	shift
	tmux new-session -s $session -d 2> /dev/null && {
		if [[ $# -ne 0 ]]; then
			tmux send-keys -t $session $@ C-m
		fi
	}
	tmux attach-session -t $session 2> /dev/null || tmux switch-client -t $session
}
