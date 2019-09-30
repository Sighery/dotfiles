# If I'm executing this script it probably means I'm already on
# $HOME/Programming/dotfiles/manjaro-setup, and I can assume SSH keys for
# GitHub have been set up
sudo pacman-mirrors --country all --api --protocol https
sudo pacman -Syyu
sudo pacman -S --needed - < official-packages.list
yay -S --needed - < aur-packages.list

# Install Fantasque Sans Mono Large Line Height No Loop K
if [ ! -d "$HOME/Programming/fantasque-sans-arch-build" ]; then
	mkdir "$HOME/Programming"
	cd "$HOME/Programming"
	git clone git@github.com:Sighery/fantasque-sans-arch-build.git
fi

cd "$HOME/Programming/fantasque-sans-arch-build"
makepkg -i --needed --syncdeps --clean
git clean -fdX

cd "$HOME/Programming/dotfiles"
# Set up both needed user and system dependencies for dotdrop
pip install -r dotdrop/requirements.txt --user
sudo pip install -r dotdrop/requirements.txt

# First install dotfiles
bash doptdrop.sh --cfg=config.yaml install

# Now install system files
sudo bash dotdrop.sh --cfg=system-config.yaml install
