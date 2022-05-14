#!/usr/bin/env bash

# Not all packages are born equal... some are only updated in Homebrew
# A huge thank you to all package mantainers for their work

# Var -------------------------------------------------------------------------

brewpath="/home/linuxbrew/.linuxbrew/bin/brew"

brew_packages=(
	fzf            # Fuzzy finder
	navi           # Cheat sheets
	btop           # Pretty resource monitor
	bitwarden-cli  # Bitwarden cli? Self descriptive
)

# Functions -------------------------------------------------------------------

is_there_brew() {
	# This fails if Homebrew is installed at a different location, nevermind 
	# trying to run this on a mac. Since this issue does not concern my case, 
	# I'm won't bother fixing it. A warning, in case you plan on using this.
	log "[brew] Checking if brew package installed"
	if [ -e "$brewpath" ]; then
		log "[brew] brew installed" ; return 0
	else
		log "[brew] brew not installed" ; return 1
	fi
}

install_brew() {
	log "[brew] Installing Homebrew"

	local script
	script="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
	script="$(wget -qO- $script)"

	_install_brew
	/bin/bash -c "NONINTERACTIVE=1 $script" 1>>"$LOG_FILE" 2>&1

	if is_there_brew; then
		log "[brew] Homebrew installed"
	else
		log "[brew] Failed to install Homebrew"
	fi
	
	# Add brew command for the rest of dotfiles execution
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

# TODO: This is unused at the moment, no plans to use it yet.
uninstall_brew() {
	log "[brew] Unistalling brew"
	local script
	script="https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh"
	script=$(wget -qO- $script)
	echo "$sudop" | /bin/bash -c "$script" -- -f 1>>"$LOG_FILE" 2>&1
	delete "/home/linuxbrew"
}

brew_is_installed() {
	local found
	log "[brew] Checking if brew package installed: $1"
	found=$( brew list | grep -E "$1" )

	if [[ $found ]]; then
		log "[brew] $1 installed" ; return 0
	else
		log "[brew] Could not find $1" ; return 1
	fi
}

brew_update() {
	log "[brew] Updating brew (all)"
	brew update 1>>"$LOG_FILE" 2>&1
}

brew_upgrade() {
	log "[brew] Upgrading brew (all)"
	brew upgrade 1>>"$LOG_FILE" 2>&1
}

brew_install() {
	log "[brew] Installing formula $1"
	brew install "$1" 1>>"$LOG_FILE" 2>&1

	if brew_is_installed "$1"; then
		log "[brew] Installed formula $1"
	else
		log "[brew] Failed to install formula $1"
	fi
}

brew_install_cask() {
	log "[brew] Installing cask $1"
	brew cask install -q "$1"

	if brew_is_installed "$1"; then
		log "[brew] Installed cask $1"
	else
		log "[brew] Failed to install cask $1"
	fi
}

# Run -------------------------------------------------------------------------

# Attemt to install homebrew first
en_arrow "Checking homebrew... "
if ! is_there_brew; then
	ern_arrow "Installing Homebrew "
	BLA::start_loading_animation "${BLA_classic[@]}"
	install_brew
	BLA::stop_loading_animation
fi

if is_there_brew; then
	er_success "Homebrew installed"
else
	# If brew is not installed, skip the rest of the file
	er_error "Failed to install Homebrew."
	log "[brew-install] brew not installed. Skipping."
	return
fi

en_arrow "Updating brew and formulae "
BLA::start_loading_animation "${BLA_classic[@]}"
brew_update
BLA::stop_loading_animation

if [ -n "$up_pkgs" ] ; then
	ern_arrow "Upgrading casks and formulae "
	BLA::start_loading_animation "${BLA_classic[@]}"
	brew_upgrade
	BLA::stop_loading_animation	
fi

if [ -n "$up_pkgs" ] ; then
	er_success "Brew up to date" # TODO: what if not though ha ha fix
else
	er_success "Brew info updated"
fi

for pkg in "${brew_packages[@]}"; do
	en_arrow "Checking $pkg"

	# Try to install the package if it isn't installed yet
	if ! brew_is_installed "$pkg"; then
		ern_arrow "Installing $pkg "

		BLA::start_loading_animation "${BLA_classic[@]}"
		brew_install "$pkg"
		BLA::stop_loading_animation
	fi

	# Echo if the package is installed at the end. This way it makes
	# no difference if the package was already installed before or not
	if brew_is_installed "$pkg"; then
		er_success "$pkg installed"
	else
		er_error "$pkg could not be installed"
	fi
done