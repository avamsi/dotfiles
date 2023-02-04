alias ...='cd ../..'
alias ..='cd ..'
# https://github.com/wincent/clipper
alias clip='tee >(nc -N localhost 8377)'
alias grep='grep --color'
alias ll='ls -al'
alias ls='ls --classify --color'
alias micro='tmicro'
alias re='grep -inrI'

cd() {
	builtin cd $@ || {
		local d=$(rd $@) && builtin cd $d && print "rd: cd'ed to $d"
	}
}

jjx() {
	local log="$(jj bgc --config-toml=ui.relative-timestamps=true log \
		--reversed --revisions=interesting)"
	# TODO: add jj resolve --list?
	local pcc="| Parent commit changes:\n$(jj bgc whatsout --revision=@- | indent)"
	# We intentionally don't use bg(c) here to let jj automatically commit
	# changes to the working copy (so it's not stale on output).
	local wcc="@ Working copy changes:\n$(jj --color=always whatsout --revision=@ | indent)"
	printf "$log\n\n$pcc\n\n$wcc"
}

jjwatch() {
	# Make the cursor invisible and turn off automatic margins (i.e., word wrapping).
	# Can be undone by cnorm and smam respectively.
	tput civis && tput rmam
	while sleep 1; do
		# TODO: tmux clear-history as well?
		local header="$(clear)Every 1.0s: jjx %-$(($(tput cols) - 45))s $(date)"
		printf "$header\n\n$(jjx)"
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
