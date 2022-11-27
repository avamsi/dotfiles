alias ...='cd ../..'
alias ..='cd ..'
# https://github.com/wincent/clipper
alias clip='tee >(nc -N localhost 8377)'
alias grep='grep --color'
alias ll='ls -al'
alias ls='ls --classify --color'
alias re='grep -inrI'

jjwatch() {
	tput civis
	local header
	while sleep 1; do
		header="$(clear)Every 1.0s: jj log && jj st %-$(($(tput cols) - 57))s $(date)"
		printf "$header\n\n$(jj --color=always log --reversed && printf '\n' && jj --color=always st)"
	done
}

# Like cd, but for tmux sessions, creates a session if needed.
td() {
	local session
	session=$1
	shift
	tmux new-session -s $session -d 2> /dev/null && {
		if [[ "$#" -ne 0 ]]; then
			tmux send-keys -t $session $@ C-m
		fi
	}
	tmux attach-session -t $session 2> /dev/null || tmux switch-client -t $session
}
