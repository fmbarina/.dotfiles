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

make_dir "$FONT_DST_DIR"

for font in "$FONT_DIR"/*; do
    if ! [ -e "$FONT_DST_DIR/$(basename "$font")" ]; then
        log "[fonts] Installing $font"
        copy "$FONT_DIR/$(basename "$font")" "$FONT_DST_DIR/$(basename "$font")"
    fi

    if [ -e "$FONT_DST_DIR/$(basename "$font")" ]; then
        log "[fonts] Installed $font"
        e_success "$(basename "$font") installed"
    else
        log "[fonts] Failed to install $font"
        e_error "$(basename "$font") could not be installed"
    fi
done