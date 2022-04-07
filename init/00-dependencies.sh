#!/usr/bin/env bash

# Stuff that will be necessary in later scripts

# Run -------------------------------------------------------------------------

### Homebrew ###
en_arrow "Checking homebrew..."
if ! is_brew_installed; then
	ern_arrow "Installing Homebrew"
	BLA::start_loading_animation "${BLA_classic[@]}"
	install_brew
	BLA::stop_loading_animation
fi

if is_brew_installed; then
	er_success "Homebrew installed"
else
	er_error "Failed to install Homebrew."
fi