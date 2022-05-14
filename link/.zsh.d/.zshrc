# p10k instant prompt - things that require input must go above!
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# User specific environment
if [ -f "$HOME/.user_env" ]; then
	source "$HOME/.user_env"
fi

# Common aliases
if [ -f "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

# Setup fzf, from .fzf.zsh
if [[ ! "$PATH" == */home/linuxbrew/.linuxbrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/linuxbrew/.linuxbrew/opt/fzf/bin"
fi
# Source shorcuts
if [ -f "/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh" ]; then
  source "/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh"
fi

# Include brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Include navi
eval "$(navi widget zsh)"

# To customize prompt, run `p10k configure` or edit ~/.zsh.d/.p10k.zsh.
[[ ! -f ~/.zsh.d/.p10k.zsh ]] || source ~/.zsh.d/.p10k.zsh
