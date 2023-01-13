alias ...='cd ../..'
alias ..='cd ..'
# https://github.com/wincent/clipper
alias clip='tee >(nc -N localhost 8377)'
alias grep='grep --color'
alias ll='ls -al'
# alias ls='ls --classify --color'
alias micro='tmicro'
alias re='grep -inrI'

_local_jj() {
	jj --no-commit-working-copy --color=always --config-toml='ui.relative-timestamps=true' $@
}

jjwatch() {
	tput civis
	while sleep 1; do
		# TODO: tmux clear-history as well?
		local header="$(clear)Every 1.0s: jj log && summary %-$(($(tput cols) - 59))s $(date)"
		local log="$(_local_jj log --reversed --revisions=interesting)"
		# TODO: add jj resolve --list?
		local pcc="| Parent commit changes:\n$(_local_jj diff --summary --revision=@- | indent)"
		# We intentionally use jj directly here instead of the _local_jj alias to let
		# jj automatically commit things to the working copy.
		local wcc="@ Working copy changes:\n$(jj --color=always diff --summary --revision=@ | indent)"
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
