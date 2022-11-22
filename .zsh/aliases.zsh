alias ...='cd ../..'
alias ..='cd ..'
alias files='nautilus'
alias grep='grep --color'
alias ll='ls -al'
alias ls='ls --classify --color'
alias re='grep -inrI'

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

tmicro() {
	tmux source ~/.tmux/reset_keys.conf
	~/bin/micro $@
	tmux source ~/.tmux/keys.conf
}
