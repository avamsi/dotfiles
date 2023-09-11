if [[ -z "$HOMEBREW_PREFIX" ]]; then
    return
fi

source "$HOMEBREW_PREFIX/share/antigen/antigen.zsh"

antigen theme romkatv/powerlevel10k

antigen bundle Aloxaf/fzf-tab; zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
antigen bundle Valiev/almostontop
antigen bundle hlissner/zsh-autopair; unset 'AUTOPAIR_PAIRS[\`]'
antigen bundle zdharma-continuum/fast-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen apply
