#!/usr/bin/env bash

# Install and update gnome shell extensions

! is_gnome && log "[gnome-config] Not gnome. Skipping." && return

# Var -------------------------------------------------------------------------

gnome_extensions=(
    'https://extensions.gnome.org/extension/906/sound-output-device-chooser/'
    'https://extensions.gnome.org/extension/1460/vitals/'
    'https://extensions.gnome.org/extension/2986/runcat/'
    'https://extensions.gnome.org/extension/3088/extension-list/'
    'https://extensions.gnome.org/extension/3193/blur-my-shell/'
    'https://extensions.gnome.org/extension/4839/clipboard-history/'
    'https://extensions.gnome.org/extension/4648/desktop-cube/'
    'https://extensions.gnome.org/extension/3843/just-perfection/'
)

# TODO: Choose one of these - actually, ideally, drop spotify
# https://extensions.gnome.org/extension/4013/spotify-controller/
# https://extensions.gnome.org/extension/4472/spotify-tray/

# Functions -------------------------------------------------------------------

gnome_id_from_link() {
    echo "$1" | awk -F'/' '{print $5}'
}

gnome_name_from_link() {
    echo "$1" | awk -F'/' '{print $6}'
}

gnome_install_ext() {
    # TODO: if on wayland, maybe don't try restarting, as it will fail
    gext "$1" --yes --restart-shell 1> /dev/null
}

# Run -------------------------------------------------------------------------

for ext in "${gnome_extensions[@]}"; do
    gextname=$(gnome_name_from_link "$ext")
	gextid=$(gnome_id_from_link "$ext")

    log "[gnome-extensions] Installing $gextid: $gextname"

    en_arrow "Checking $gextname"
	gnome_install_ext "$gextid"
    er_success "$gextname installed"
done

