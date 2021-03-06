#!/usr/bin/env bash

# TODO: might be worth looking into cloning repos and executing appropriate
# install commands for each one of them. Then, in subsequent runs, it would
# be possible to update the repo and just execute the install command again.
# I think.

# If not running a known distro, skip this file
! is_known_distro && log "[github_install] Unkown distro. Skipping." && return

# Run -------------------------------------------------------------------------

for pkg in "${!gh_packages[@]}"; do
	en_arrow "Checking $pkg "
	
	# Try to install the package if it isn't installed yet
	if ! gh_is_installed "$pkg"; then
		ern_arrow "Downloading $pkg "
		BLA::start_loading_animation "${BLA_classic[@]}"
		download "$(ghlatest "${gh_packages[$pkg]}" $extension)"
		BLA::stop_loading_animation

		file="$(ls -A "$DOWN_DIR" | grep -E "$pkg")"
		file="$DOWN_DIR/$file"

		ern_arrow "Installing $pkg "
		BLA::start_loading_animation "${BLA_classic[@]}"
		install_file "$file"
		BLA::stop_loading_animation
	fi

	# Echo if the package is installed at the end. This way it makes
	# no difference if the package was already installed before or not	
	if gh_is_installed "$pkg"; then
		er_success "$pkg installed"
	else
		er_error "$pkg could not be installed"
	fi	
done