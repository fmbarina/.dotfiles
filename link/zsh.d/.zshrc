# p10k instant prompt - things that require input must go above!
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# User specific environment
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.dotfiles/bin:$PATH"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Source common aliases
if [ -f "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

# Include brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Include navi
eval "$(navi widget zsh)"

# To customize prompt, run `p10k configure` or edit ~/.zsh.d/.p10k.zsh.
[[ ! -f ~/.zsh.d/.p10k.zsh ]] || source ~/.zsh.d/.p10k.zsh
