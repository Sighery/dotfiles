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

sudo pacman -S --needed - < official-packages.list
sudo pacman -Scc
yay -S --needed - < aur-packages.list
yay -Scc

# Install Fantasque Sans Mono Large Line Height No Loop K
if [ ! -d "$HOME/Programming/fantasque-sans-arch-build" ]; then
	cd "$HOME/Programming"
	git clone https://github.com/Sighery/fantasque-sans-arch-build.git
fi

cd "$HOME/Programming/fantasque-sans-arch-build"
makepkg --needed --syncdeps --clean
sudo pacman -U otf*.pkg.tar.xz
git clean -fdX

cd "$HOME/Programming/dotfiles"
# Set up both needed user and system dependencies for dotdrop
pip install -r dotdrop/requirements.txt --user
sudo pip install -r dotdrop/requirements.txt

# First install dotfiles
bash dotdrop.sh --cfg=config.yaml --profile=sater-manjaro install

# Now install system files
sudo bash dotdrop.sh --cfg=system-config.yaml --profile=basic install