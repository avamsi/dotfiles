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
		header="$(clear)Every 1.0s: jj log && jj st %-$(($(tput cols) - 57))s $(date)"
		log=$(jj --color=always log --reversed)
		pst=$(jj --color=always show --summary @- | tail +8 | while read line; do; print "\t$line"; done)
		st=$(jj --color=always show --summary @ | tail +8 | while read line; do; print "\t$line"; done)
		reset='\e[0m'
		printf "$header\n\n$log\n\n| Parent commit changes:\n$pst$reset\n\n| Working copy changes:\n$st$reset"
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
