autoload -Uz compinit
compinit

# Also see fzf-tab in plugins.zsh.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/completions-cache/

source <(jj debug completion --zsh | sed '$d')
compdef _jj jj
