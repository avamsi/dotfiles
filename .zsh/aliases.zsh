alias ...='cd ../..'
alias ..='cd ..'
# https://github.com/wincent/clipper
alias clip='tee >(nc -N localhost 8377)'
alias grep='grep --color'
alias ll='ls -al'
alias ls='ls --classify --color'
alias re='grep -inrI'

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
