profile="basic-manjaro"

usage() {
	printf "Usage: bash $0 [-p|--profile dotdrop-profile]\n"
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

while [ "$1" != "" ]; do
	case $1 in
		-p | --profile )	shift
							profile="$1"
							;;
		-h | --help )		usage
							exit 0
							;;
		* )					usage
							exit 1
	esac
	shift
done

# If I'm executing this script it probably means I'm already on
# $HOME/Programming/dotfiles/manjaro-setup
sudo pacman-mirrors --country all --api --protocol https
sudo pacman -Syyu
sudo pacman -Scc

# Wireguard needs Linux headers. Figure out the headers dynamically
HEADERS="linux"
HEADERS+=`uname -r | cut -d"." -f1`
HEADERS+=`uname -r | cut -d"." -f2`
HEADERS+="-headers"
sudo pacman -S --needed "$HEADERS"

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile complete
# Enable rustup completions
mkdir -p "$HOME/.local/share/bash-completion/completions/"
rustup completions bash > "$HOME/.local/share/bash-completion/completions/rustup"

sudo pacman -S --needed - < official-packages.list
sudo pacman -Scc
yay -S --needed - < aur-packages.list
yay -Scc
docker_credentials_pass_posthelp

# One more thing to hopefully set up Kitty as the default terminal
if [ ! -f "/usr/bin/terminal.original" ]; then
	sudo mv /usr/bin/terminal /usr/bin/terminal.original || :
	sudo ln /usr/bin/kitty /usr/bin/terminal
fi

if [ ! -d "$HOME/Programming" ]; then
	mkdir "$HOME/Programming"
fi

# Install Fantasque Sans Mono Large Line Height No Loop K
install_github_package \
"https://github.com/Sighery/fantasque-sans-arch-build.git" \
"otf*.pkg.tar.xz"

# Install my fork of i3exit
install_github_package "https://github.com/Sighery/i3exit.git"

# Install i3-resurrect-manager
install_github_package "https://github.com/Sighery/i3-resurrect-manager.git"

# Install Pulse only if not already executed before
# The script isn't smart enough to notice past installations so query some of
# the packages it installs. If the pacman query command fails it means at
# least one of the packages is not installed, so go ahead with the script
pulse_libraries=(manjaro-pulse pa-applet pavucontrol)
pacman -Qi "${pulse_libraries[@]}" > /dev/null 2>&1 || install_pulse

cd "$HOME/Programming/dotfiles"
# Set up both needed user and system dependencies for dotdrop
pip install -r dotdrop/requirements.txt --user
sudo pip install -r dotdrop/requirements.txt

# First install dotfiles
bash dotdrop.sh --cfg=config.yaml --profile="$profile" install

# Now install system files
sudo bash dotdrop.sh --cfg=system-config.yaml --profile="$profile" install

# Let Manjaro set our time and date automatically
# https://wiki.manjaro.org/System_Maintenance#Time_and_Date
timedatectl set-ntp true
