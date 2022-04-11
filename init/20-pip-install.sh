#!/usr/bin/env bash

# If pip not installed, skip this file
! (pm_is_installed python3-pip) \
	&& log "[pip] Pip not installed. Skipping." && return

# Run -------------------------------------------------------------------------

# TODO: pip upgrade all?

for pkg in "${pip_packages[@]}"; do
	en_arrow "Checking $pkg "
	
	# Try to install the package if it isn't installed yet
	if ! pip_is_installed "$pkg"; then
		ern_arrow "Installing $pkg "
		
		BLA::start_loading_animation "${BLA_classic[@]}"
		pip_install "$pkg"
		BLA::stop_loading_animation
	fi

	# Echo if the package is installed at the end. This way it makes
	# no difference if the package was already installed before or not	
	if pip_is_installed "$pkg"; then
		er_success "$pkg installed"
	else
		er_error "$pkg could not be installed"
	fi	
done
