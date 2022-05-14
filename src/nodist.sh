#!/usr/bin/env bash

# Var -------------------------------------------------------------------------

log_dist='nodist' # replaced by distro name, this value should never be used.

# Functions -------------------------------------------------------------------

### File interaction ###

delete() {
	if [ -e "$1" ]; then
		log "[delete] Deleting $1"
		rm -rf "$1"
	else
		log "[delete] File/dir does not exist: $1"
	fi
}

backup() {
	local src

	src="$1"
	
	if ! [ -e "$src" ]; then
		log "[backup] Can not backup nonexistent target: $src"
		abort
	fi

	if ! [ -e "$BKP_DIR" ]; then
		make_dir "$BKP_DIR"
	elif [ -e "$BKP_DIR/$(basename "$src")" ]; then
		log "[backup] $src already exists, stopped. Please remove or rename it."
		abort "$src already backed up, stopped. Please remove or rename it."
	fi

	if [ -d "$src" ]; then
		log "[backup] Backing up directory: $src"
		cp -r  "$src" "$BKP_DIR"
	else
		log "[backup] Backing up file: $src"
		cp -r  "$src" "$BKP_DIR"
	fi

	[ -z $dotbkp ] && dotbkp=yes
}

rsymlink() {
	local link

	link="$1"

	if ! [ -L "$link" ]; then
		log "[rsymlink] Not a link: $link"
		log "[rsymlink] Stopping"
		abort
	fi

	# Shellcheck may call it useless, but the echo is necessary for string comp
	echo "$(readlink -f $link)"
}

symlink() {
	local link
	local tgt
	local points
	
	link="$1"
	tgt="$2"

	if [ -e "$link" ]; then
		if [ -L "$link" ]; then
			points=$(rsymlink "$link")
			if [ "$points" == "$tgt" ]; then
				log "[link] Already linked $link" && return
			fi

			log "[link] Symlink already exists: $link"
		else
			log "[link] Directory or file already exists: $link"
		fi

		backup "$link"
		log "[link] Removing old file: $link"
		delete "$link"
	fi
	
	if ! [ -e "$link" ]; then
		log "[link] Creating symlink: $link To: $tgt"
		ln -s "$tgt" "$link" # this command confuses me greatly!
	else
		log "[link] Could not create symlink: $link"
	fi
}

copy() {
	local src
	local dest

	src="$1"
	dest="$2"

	if [ -e "$dest" ]; then
		if [ -n "$INSTALLED" ]; then
			log "[copy] Already copied $dest" && return
		fi
		
		log "[copy] File already exists: $dest"
		backup "$dest"
		log "[copy] Removing old file: $dest"
		delete "$dest"
	fi
	
	if ! [ -e "$dest" ]; then
		log "[copy] Copying: $src To: $dest"
		cp -r "$src" "$dest"
	else
		log "[copy] Could not copy $link"
	fi
}

extract() {
	local compacted
	local dest
	compacted="$1"
	dest="$2"

	log "[extract] Extracting $compacted to $dest"
	tar --directory "$dest" \
		--extract --overwrite --file "$compacted" 1>"$LOG_OTH_FILE"
}

run_script() {
	log "[run] Running: $1"
	# shellcheck source=/dev/null
	source "$1"
}

shorten_initf() {
	local header_name
	header_name="$(basename "$1")"
	header_name="${header_name:3:(-3)}"
	echo "$header_name"
}

remove_extension() {
	local file_name
	file_name="$(basename "$1")"
	echo "${file_name%.*}"
}

### Web ###

_download() {
	log "[down] Downloading $1 to $2"
	wget -q -P "$2" "$1"
}

download() {
	_download "$1" "$DOWN_DIR"
}

### git ###

clone() {
	local repo
	local dest
	repo="$1"
	dest="$2"

	if [ -e "$dest" ]; then
		log "[clone] $dest already exists. Attempting to clone anyway."
	fi

	log "[clone] Cloning $repo to $dest"
	git clone -q --recursive "$repo" "$dest"
}


### Desktop enviroment ###

# Thanks to
# https://unix.stackexchange.com/questions/116539/
get_de() {
	# Get desktop environment
	local denv

	if [ "$XDG_CURRENT_DESKTOP" = "" ]; then
		denv=$(echo "$XDG_DATA_DIRS" | sed 's/.*\(xfce\|kde\|gnome\).*/\1/')
	else
		denv=$XDG_CURRENT_DESKTOP
	fi
	
	denv=${denv,,}  # convert to lower case
	echo "$denv"
}

is_gnome() {
	[[ "$(get_de)" = *"gnome"* ]]
}

### github ###

# Not really github specific, but that's what it's used for by dotfiles

gh_is_installed() {
	local found
	log "[nodist] Checking if non-pm package installed: $1"
	found="$(find /opt -maxdepth 5 -name "*${1}*" -print)"

	if [ -n "$found" ]; then
		log "[nodist] Found: $1" ; return 0
	else
		log "[nodist] Could not find: $1" ; return 1
	fi
}

### rust ###

# TODO: consider install rust automatically or manually
# Not every computer needs rust...? Nah they do. Unless... Yeah rust. No. Rust?
# rust_is_installed() {
# 	[ "$(rustc --version)" ]
# }

# rust_install() {
# 	url https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path >> "$LOG_FILE"
# }

### Distro-specific functions ###

# These themselves do little but log, the actual implementation per distro
# is provided by the distro-specific files src/(distro-name).sh.

install_file() {
	log "[$log_dist] Installing by file: $1"
	_install_file "$1"
}

pm_update() {
	log "[$log_dist] Updating packages"
	_pm_update
}

pm_upgrade() {
	log "[$log_dist] Upgrading packages"
	_pm_upgrade
}

pm_clean() {
	log "[$log_dist] Cleaning packages"
	_pm_clean
}

pm_is_installed() {
	log "[$log_dist] Checking if package installed: $1"
 	_pm_is_installed "$1"
}

pm_install() {
	log "[$log_dist] Installing $1"
	_pm_install "${1}"

	if pm_is_installed "$1"; then
		log "[$log_dist] Installed $1"
	else
		log "[$log_dist] Failed to install $1"
	fi
}

vscode_add() {
	log "[$log_dist] Adding vscode source"
	_vscode_add
}
