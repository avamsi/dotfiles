if [[ -z "$HOMEBREW_PREFIX" ]]; then
	return
fi

source "$HOMEBREW_PREFIX/share/antigen/antigen.zsh"

antigen theme romkatv/powerlevel10k

antigen bundle Aloxaf/fzf-tab
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

antigen bundle Valiev/almostontop
antigen bundle hlissner/zsh-autopair
antigen bundle zdharma-continuum/fast-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen apply

unset 'AUTOPAIR_PAIRS[`]'

source "$HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh"
