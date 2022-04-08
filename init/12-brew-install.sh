#!/usr/bin/env bash

# Not all packages are born equal... some are only updated in Homebrew
# A huge thank you to all package mantainers for their work

# If brew is not installed, skip this file
! is_brew_installed && log "[brew-install] brew not installed. Skipping." && return

# Run -------------------------------------------------------------------------

en_arrow "Updating brew and formulae "
BLA::start_loading_animation "${BLA_classic[@]}"
brew_update
BLA::stop_loading_animation

if [ "$up_pkgs" == 'y' ] ; then
	ern_arrow "Upgrading casks and formulae "
	BLA::start_loading_animation "${BLA_classic[@]}"
	brew_upgrade
	BLA::stop_loading_animation	
fi

if [ "$up_pkgs" == 'y' ] ; then
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
		er_error "Failed to install $pkg"
	fi
done