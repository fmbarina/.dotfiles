#!/usr/bin/env bash

# This file should be sourced unless when running fedora

# If not running fedora, stop
! is_fedora && log "[fedora] Incompatible source. Stopping." && abort

# Var -------------------------------------------------------------------------

extension="rpm" 
log_dist="fedora" # Unused here, used in nodist.sh

pm_packages=(
	util-linux           # Linux utilities
	util-linux-user	     # User utilities
	python3              # Python3
	python3-pip          # The python package manager
	p7zip                # Better than Winrar
	p7zip-plugins        # ~plugins
	htop                 # Cli process monitor
	tmux                 # Terminal multiplexer
	wget                 # File retriever package
	curl                 # Data transfer tool
	fd-find              # Find files
	ripgrep              # Regex search
	exa                  # ls alternative
	cowsay               # Cowsay
	ncdu                 # Directory listing CLI tool
	trash-cli            # Trash cli tool
	neofetch             # Pretty CLI system information just because
	vim                  # Enhanced-vim text editor
	zsh                  # Z shell
	ShellCheck           # Bash/sh shell script linter
	gnome-tweaks         # Gnome tweak enhancements
	code                 # VSCode
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
