#!/usr/bin/env bash

# This file should be sourced unless when running fedora

# If not running fedora, stop
! is_fedora && log "[fedora] Incompatible source. Stopping." && abort

# Var -------------------------------------------------------------------------

extension="rpm" 
log_dist="fedora" # Unused here, used in nodist.sh

pm_packages=(
	@development-tools   # Big depencies. Some are repeated below.
	# TODO: Says it couldn't be installed because I'm checking in a dumb way
	#libstdc++-static	 # TODO: wait, is this in @dev?
	util-linux           # Linux utilities
	util-linux-user	     # User utilities
	dbus                 # Application messaging system
	unzip				 # Unzip utility
	jq					 # JSON processor
	perl                 # Perl
	python3              # Python3
	python3-pip          # The python package manager
	p7zip                # Better than Winrar
	p7zip-plugins        # ~plugins
	bash                 # Yes this is redundant
	htop                 # Cli process monitor
	tmux                 # Terminal multiplexer
	wget                 # File retriever package
	curl                 # Data transfer tool
	fzf                  # Fuzzy finder
	fd-find              # Find files
	ripgrep              # Regex search
	exa                  # ls alternative
	cowsay               # Cowsay
	ncdu                 # Directory listing CLI tool
	trash-cli            # Trash cli tool
	neofetch             # Pretty CLI system information just because
	neovim               # Vim-based text editor
	python3-neovim       # python support
	zsh                  # Z shell
	code                 # VSCode
	ShellCheck           # Bash/sh shell script linter
	valgrind             # Memory utility
	gnome-tweaks         # Gnome tweak enhancements
)

# Array of key&value pairs as (keyname)&(username/repo)
# key:   used to check if package is installed, find files, etc.
# value: used to download the package from github
declare -A gh_packages
gh_packages['logisim']='logisim-evolution/logisim-evolution'

# Functions -------------------------------------------------------------------

_install_file() {
	sudo_do "rpm -i $1"
}

_pm_update() {
	dnf -q check-update 1> /dev/null
}

_pm_upgrade() {
	sudo_do 'dnf -y upgrade'
}

_pm_clean() {
	sudo_do 'dnf -y autoremove'
}

_pm_is_installed() {
 	found=$( dnf list --installed | grep -E "^$1" )
	[[ $found ]] && return 0 || return 1
}

_pm_install() {
	sudo_do "dnf -y install $1"
}

_vscode_add() {
	# Add vscode -> https://code.visualstudio.com/docs/setup/linux
	# Yes, this is very hacky TODO: fix this.
	sudo_do 'rpm --import https://packages.microsoft.com/keys/microsoft.asc'
	sudo_do 'touch /etc/yum.repos.d/vscode.repo'
	echo "$sudop" | sudo -S sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}

_install_brew() {
	sudo_do "dnf install --assumeyes @development-tools"
}
