#!/usr/bin/env bash

# Install and update gnome shell extensions

! is_gnome && log "[gnome-config] Not gnome. Skipping." && return

# Var -------------------------------------------------------------------------

# TODO: numbers aren't very useful. An array could help here
gnome_extensions=(
    906  # https://extensions.gnome.org/extension/906/sound-output-device-chooser/
    1460 # https://extensions.gnome.org/extension/1460/vitals/
    #  Or, https://extensions.gnome.org/extension/2986/runcat/
    3088 # https://extensions.gnome.org/extension/3088/extension-list/
    3193 # https://extensions.gnome.org/extension/3193/blur-my-shell/
    4839 # https://extensions.gnome.org/extension/4839/clipboard-history/
)

# TODO: Choose one of these
# https://extensions.gnome.org/extension/4013/spotify-controller/
# https://extensions.gnome.org/extension/4472/spotify-tray/

# Functions -------------------------------------------------------------------

gnome_install_ext() {
    # TODO: if on wayland, maybe don't try restarting, as it will fail
    # for now, we'll just use this: 
    req_reboot=yes
    gext "$1" --yes --restart-shell 1> /dev/null
}

# Run -------------------------------------------------------------------------

for ext in "${gnome_extensions[@]}"; do
	en_arrow "Checking $ext "
	gnome_install_ext "$ext"
    er_success "$ext installed"
done

