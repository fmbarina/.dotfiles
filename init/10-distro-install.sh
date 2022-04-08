#!/usr/bin/env bash

# If not running a known distro, skip this file
! is_known_distro && log "[distro_install] Unkown distro. Skipping." && return

# Run -------------------------------------------------------------------------

# Update the package list
en_arrow "Updating information "
BLA::start_loading_animation "${BLA_classic[@]}"
pm_update
BLA::stop_loading_animation

# Upgrade everything with package manager
if [ "$up_pkgs" == 'y' ] ; then
	ern_arrow "Upgrading packages "
	BLA::start_loading_animation "${BLA_classic[@]}"
	pm_upgrade
	BLA::stop_loading_animation	
fi

er_success "Packages up to date" # TODO: what if they aren't though ha ha fix

# Install package manager packages
if ! pm_is_installed 'code'; then
	vscode_add # VSCode is special because it has to be added first
	# TODO: OBS: there may be other such packages in the future, (ex: older php 
	# versions) so it's worth considering setting up proper functions to do so 
	# or similar and refactoring vscode_add() to use them.
fi

for pkg in "${pm_packages[@]}"; do
	en_arrow "Checking $pkg"

	# Try to install the package if it isn't installed yet
	if ! pm_is_installed "$pkg"; then
		ern_arrow "Installing $pkg "

		BLA::start_loading_animation "${BLA_classic[@]}"
		pm_install "$pkg"
		BLA::stop_loading_animation
	fi

	if pm_is_installed "$pkg"; then
		er_success "$pkg installed"
	else
		er_error "Failed to install $pkg"
	fi
done

# Cleanup
pm_clean
