#!/bin/bash
# set -x

default_normal_profile_name='basic-manjaro'
normal_profile_name=$default_normal_profile_name
normal_profile_config="$HOME/Programming/dotfiles/config.yaml"
default_sudo_profile_name='basic-manjaro'
sudo_profile_name=$default_sudo_profile_name
sudo_profile_config="$HOME/Programming/dotfiles/system-config.yaml"

# Control whether pacman/yay should clean their caches after any command
cleanup_packages=0

usage() {
	printf -- "Usage: bash $0 "
	printf -- '[--cleanup-packages]\n'
	printf -- '\t[--normal-profile-name basic-manjaro] '
	printf -- '[--normal-profile-config config.yaml]\n'
	printf -- '\t[--sudo-profile-name basic-manjaro] '
	printf -- '[--sudo-profile-config system-config.yaml]\n'
	printf -- '\n'
	printf -- 'ARGUMENTS\n'
	printf -- '--cleanup-packages: Clean package caches of pacman and yay.\n'
	printf -- '\t\tDEFAULT: false\n'
	printf -- '--normal-profile-name: Profile name of the normal dotfiles.\n'
	printf -- '\t\tDEFAULT: $(hostname) if valid or basic-manjaro\n'
	printf -- '--normal-profile-config: Path of the normal dotfiles config.\n'
	printf -- '\t\tDEFAULT: $HOME/Programming/dotfiles/config.yaml\n'
	printf -- '--sudo-profile-name: Profile name of the sudo dotfiles.\n'
	printf -- '\t\tDEFAULT: $(hostname) if valid or basic-manjaro\n'
	printf -- '--sudo-profile-config: Path of the sudo dotfiles config.\n'
	printf -- '\t\tDEFAULT: $HOME/Programming/dotfiles/system-config.yaml\n'
}

docker_credentials_pass_posthelp() {
	printf "After installing the docker-credentials-pass you need to:\n"
	printf "\t1. Create a new gpg2 key:\n"
	printf "\t\tgpg2 --gen-key\n"
	printf "\t2. Initialize pass with the newly generated key:\n"
	printf "\t\tpass init \"Name\"\n"
}

install_github_package() {
	local github_link="$1"
	local package_install="$2"
	local repo_name=$(basename "$github_link" | sed "s/\.git//")
	local starting_cwd=$(pwd)

	if [ -d "$HOME/Programming/$repo_name" ]; then
		rm -rf "$HOME/Programming/$repo_name"
	fi

	cd "$HOME/Programming"
	git clone --recurse-submodules -j8 "$github_link"
	cd "$HOME/Programming/$repo_name"

	makepkg --needed --syncdeps --clean

	if [ -n "$package_install" ]; then
		sudo pacman -U --needed "$package_install"
	else
		sudo pacman -U --needed *.pkg.tar.xz
	fi

	git clean -fdX
	cd "$starting_cwd"
}

hostname_is_dotdrop_profile() {
	# If hostname is a valid profile name, then it will set itself as the
	# default profile name, unless a specific one is provided through the CLI
	# profile_type can be "normal" or "sudo"
	local profile_type="$1"
	local profile_config=$(basename "$2")

	local name=$(hostname)

	# This script might be called from a subdirectory, so check if the config
	# files are declared in this directory or upwards until root
	local starting_cwd=$(pwd)
	local config_path="$starting_cwd/$profile_config"
	while [ "$(pwd)" != '/' ]; do
		if [ -e "$profile_config" ]; then
			local current_cwd=$(pwd)
			config_path="$current_cwd/$profile_config"
			break
		fi
		cd ..
	done

	cd "$starting_cwd"

	if yq -e '.profiles["'"$name"'"]' "$config_path" > /dev/null 2>&1; then
		if [ "$profile_type" == "normal" ]; then
			normal_profile_name="$name"
		elif [ "$profile_type" == "sudo" ]; then
			sudo_profile_name="$name"
		fi
	fi

	return 0
}

while [ "$1" != "" ]; do
	case $1 in
		--normal-profile-name )
			shift
			normal_profile_name="$1"
			;;
		--normal-profile-config )
			shift
			normal_profile_config="$1"
			;;
		--sudo-profile-name )
			shift
			sudo_profile_name="$1"
			;;
		--sudo-profile-config )
			shift
			sudo_profile_config="$1"
			;;
		--cleanup-packages )
			cleanup_packages=1
			;;
		-h | --help )
			usage
			exit 0
			;;
		* )
			usage
			exit 1
	esac
	shift
done

# If I'm executing this script it probably means I'm already on
# $HOME/Programming/dotfiles/manjaro-setup
sudo pacman-mirrors --country all --api --protocol https
sudo pacman -Syyu
if ((cleanup_packages)); then sudo pacman -Scc; fi

# Wireguard needs Linux headers. Figure out the headers dynamically
HEADERS="linux"
HEADERS+=`uname -r | cut -d"." -f1`
HEADERS+=`uname -r | cut -d"." -f2`
HEADERS+="-headers"
sudo pacman -S --needed "$HEADERS"

# Install Rust if not already installed
if ! rustup --version > /dev/null 2>&1; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
	| sh -s -- --profile complete
	# Enable rustup completions
	mkdir -p "$HOME/.local/share/bash-completion/completions/"
	rustup completions bash > \
	"$HOME/.local/share/bash-completion/completions/rustup"
fi

sudo pacman -S --needed - < official-packages.list
if ((cleanup_packages)); then sudo pacman -Scc; fi
yay -S --needed --norebuild --noredownload - < aur-packages.list
if ((cleanup_packages)); then yay -Scc; fi

# One more thing to hopefully set up Kitty as the default terminal
if [ ! -f "/usr/bin/terminal.original" ]; then
	sudo mv /usr/bin/terminal /usr/bin/terminal.original || :
	sudo ln /usr/bin/kitty /usr/bin/terminal
fi

if [ ! -d "$HOME/Programming" ]; then
	mkdir "$HOME/Programming"
fi

# Install Pulse only if not already executed before
# The script isn't smart enough to notice past installations so query some of
# the packages it installs. If the pacman query command fails it means at
# least one of the packages is not installed, so go ahead with the script
pulse_libraries=(manjaro-pulse pa-applet pavucontrol)
pacman -Qi "${pulse_libraries[@]}" > /dev/null 2>&1 || install_pulse

if [ "$default_normal_profile_name" == "$normal_profile_name" ]; then
	hostname_is_dotdrop_profile "normal" "$normal_profile_config"
fi

if [ "$default_sudo_profile_name" == "$sudo_profile_name" ]; then
	hostname_is_dotdrop_profile "sudo" "$sudo_profile_config"
fi

cd "$HOME/Programming/dotfiles"
# Set up both needed user and system dependencies for dotdrop
pip install -r dotdrop/requirements.txt --user
sudo pip install -r dotdrop/requirements.txt

# First install dotfiles
bash dotdrop.sh \
--cfg="$normal_profile_config" --profile="$normal_profile_name" install

# Now install system files
sudo bash dotdrop.sh \
--cfg="$sudo_profile_config" --profile="$sudo_profile_name" install

# After setting the system files, we'll have pacman.conf set with my custom
# ArchLinux repo at http://archrepo.sighery.com, so update and install custom
# packages
sudo pacman -Syy
sudo pacman -S --needed - < sighery-archrepo-packages.list
if ((cleanup_packages)); then sudo pacman -Scc; fi
docker_credentials_pass_posthelp

# Let Manjaro set our time and date automatically
# https://wiki.manjaro.org/System_Maintenance#Time_and_Date
if [ "$(timedatectl show --property=NTP --value)" == "no" ]; then
	timedatectl set-ntp true
fi
