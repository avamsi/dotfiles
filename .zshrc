eval "$(/opt/homebrew/bin/brew shellenv)"
# eval "$(devbox global shellenv)"
# export HOMEBREW_PREFIX="$DEVBOX_PACKAGES_DIR"

# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE

export COLORTERM='truecolor'
export DISPLAY=':0'
export EDITOR='tmicro'
export TERM='xterm-256color'

export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"
export PATH="${GOPATH:-$HOME/go}/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"

autoload -Uz compinit
compinit

source ~/dotfiles/zsh/aliases.zsh
source ~/dotfiles/zsh/fzf.zsh
source ~/dotfiles/zsh/keys.zsh
source ~/dotfiles/zsh/options.zsh
source ~/dotfiles/zsh/plugins.zsh

# https://github.com/avamsi/axl
(( ${+commands[axl]} )) && source <(axl hooks zsh)
# export AXL_NOTIFY=...

# https://github.com/martinvonz/jj
# (( ${+commands[jj]} )) && source <(jj util completion zsh)
(( ${+commands[jj]} )) && source <(COMPLETE=zsh jj)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
