alias ...='cd ../..'
alias ..='cd ..'
# https://github.com/wincent/clipper
# alias clip='tee >(nc -N localhost 8377)'
alias grep='grep --color'
alias jjw='viddy --skip-empty-diffs --unfold "jjx 2>&1"'
alias ll='ls -al'
alias ls='ls -F --color'
alias micro='tmicro'
alias re='grep -inrI'
alias rm='safe-rm'
alias sudo='sudo '

cd() {
	# Keep the original cd error hidden for if rd succeeds below.
	builtin cd $@ 2>/tmp/rd-cd-err || {
		# Note: don't try to "fix" this by adding `local`, it doesn't work.
		# For whatever reason, the `&&` chaining behaviour is lost with it.
		d=$(rd $@) && builtin cd $d || {
			# No luck, show the original error as well.
			cat /tmp/rd-cd-err
			return 1
		}
	}
}

# Like cd, but for tmux sessions, creates a session if needed.
# Usage: td session [command]
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
