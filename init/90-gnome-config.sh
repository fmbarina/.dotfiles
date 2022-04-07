#!/usr/bin/env bash

! is_gnome && log "[gnome-config] Not gnome. Skipping." && return

#Usability Improvements
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.shell.overrides workspaces-only-on-primary false
gsettings set org.gnome.desktop.session idle-delay 0

#Nautilus (File Manager) Usability
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
gsettings set org.gnome.nautilus.list-view use-tree-view true

# Assuming that if the last command was successfull, then all must have been
# TODO: consider evaluating this more carefully
if [ $? ]; then
	log "[gnome-config] configured gnome"
	e_success "gnome configured"
else
	log "[gnome-config] failed to configure gnome"
	e_error "gnome configuration failed"
fi