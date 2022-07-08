#!/usr/bin/env bash

# If there are no fonts to install, skip this file
! [ -d "$FONT_DIR" ] \
	&& log "[fonts] No fonts directory. Skipping." && return
! [ "$(ls "$FONT_DIR")" ] \
	&& log "[fonts] No fonts to install. Skipping." && return

# Var -------------------------------------------------------------------------

FONT_DST_DIR="$HOME/.local/share/fonts"

# Run -------------------------------------------------------------------------

e_header "Installing fonts"

mkdir -p "$FONT_DST_DIR"
mkdir -p "$FONT_DIR/.extract"

for obj in "$FONT_DIR"/*; do
	font="$(basename "$obj")"

	if [[ "$font" == *."tar" ]]; then
		font="$(remove_extension "$font")"
	fi

	if ! [ -e "$FONT_DST_DIR/$font" ]; then
		if [[ "$font" == *."tar" ]]; then
			extract "$obj" "$FONT_DIR/.extract"
			obj="$FONT_DIR/.extract/$font"
		fi

		log "[fonts] Installing $font"
		copy "$obj" "$FONT_DST_DIR/$font"
	fi

	if [ -e "$FONT_DST_DIR/$font" ]; then
		log "[fonts] $font installed"
		e_success "$font installed"
	else
		log "[fonts] Failed to install $font"
		e_error "$font could not be installed"
	fi
done

en_arrow 'Refreshing font cache'
BLA::start_loading_animation "${BLA_classic[@]}"
sudo_do 'sudo fc-cache -f'
BLA::stop_loading_animation
er_success 'Font cache refreshed'

delete "$FONT_DIR/.extract"