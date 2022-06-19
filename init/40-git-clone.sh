#!/usr/bin/env bash

# This script's format is a little different since repositories may need to be
# clone to different locations. I didn't see an easy&simple way to handle that,
# and honestly, right now ti doesn't matter.

# Var -------------------------------------------------------------------------

[ -n "$ZDOTDIR" ] || ZDOTDIR="$HOME/.zsh.d"

# Run -------------------------------------------------------------------------

en_arrow 'Checking Prezto'
if ! [ -e "$ZDOTDIR/.zprezto" ]; then
	ern_arrow 'Cloning Prezto '
	BLA::start_loading_animation "${BLA_classic[@]}"
	clone 'https://github.com/sorin-ionescu/prezto.git' "$ZDOTDIR/.zprezto"
	BLA::stop_loading_animation
fi

if [ -e "$ZDOTDIR/.zprezto/.git" ]; then
	er_success 'Cloned Prezto'
else
	er_error 'Could not clone Prezto'
fi
