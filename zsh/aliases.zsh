alias ...='cd ../..'
alias ..='cd ..'
# https://github.com/wincent/clipper
alias clip='tee >(nc -N localhost 8377)'
alias grep='grep --color'
alias jjw='viddy --unfold jjx'
alias ll='ls -al'
alias ls='ls --classify --color'
alias micro='tmicro'
alias re='grep -inrI'

cd() {
	builtin cd $@ || {
		local d=$(rd $@) && builtin cd $d && print "rd: cd'ed to $d"
	}
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
