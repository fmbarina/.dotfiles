# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

# User specific environment and startup programs
if ! [[ ":$PATH:" == *":$BIN_DIR:"* ]]; then
	export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.dotfiles/bin:$PATH"
fi
