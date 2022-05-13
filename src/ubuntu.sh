#!/usr/bin/env bash

# This file should be sourced unless when running ubuntu

# If not running fedora, stop
! is_ubuntu && log "[ubuntu-apt] Incompatible source. Stopping." && abort

# Var -------------------------------------------------------------------------

extension="deb" 
log_dist="ubuntu" # Unused here, used in nodist.sh

pm_packages=(
	util-linux           # Linux utilities
	python3              # Python3
	python3-pip          # The python package manager
	python-is-python3    # python to python3 symlink
	p7zip-full           # Better than Winrar
	p7zip-rar            # Better than Winrar
	bash                 # Yes this is redundant
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
	neovim               # Vim-based text editor
	python3-neovim       # python support
	zsh                  # Z shell
	code                 # vscode 
	shellcheck           # Bash/sh shell script linter
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
	sudo_do "dpkg --install $1"
}

_pm_update() {
	sudo_do 'apt-get update'
}

_pm_upgrade() {
	sudo_do 'apt-get -y upgrade'
}

_pm_clean() {
	sudo_do 'apt-get -y autoremove'
}

_pm_is_installed() {
	dpkg -s "$1" 2>&1 | \
		grep Status > "$LOG_OTH_FILE" 2>&1 && return 0 || return 1
}

_pm_install() {
	sudo_do "apt-get -y install $1"
}

_vscode_add() {
	# Add vscode -> https://code.visualstudio.com/docs/setup/linux
	# Yes, this is very hacky TODO: fix this.
	sudo_do "apt-get -y install gpg"
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo_do "install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/"
	echo "$sudop" | sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' # this is a bit hacky
	delete "packages.microsoft.gpg"
	sudo_do "apt-get install -y apt-transport-https"
}

_install_brew() {
	sudo_do "apt-get install --assume-yes build-essential"
}
