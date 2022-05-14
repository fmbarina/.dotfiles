# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if [ -f "$HOME/.user_env" ]; then
	. "$HOME/.user_env"
fi

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

# Setup fzf, from .fzf.zsh
if [[ ! "$PATH" == */home/linuxbrew/.linuxbrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/linuxbrew/.linuxbrew/opt/fzf/bin"
fi
# Source shorcuts
if [ -f "/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.bash" ]; then
  . "/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.bash"
fi

unset rc