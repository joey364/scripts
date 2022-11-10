#!/usr/bin/env bash
set -eo pipefail

echo "this should be run after running the install.sh file in the dotfiles repo successfully"

cargo_pkgs=(
	"bat"
	# "exa"
	"fd-find"
	"ripgrep"
	"stylua"
	"tealdeer"
)

install_cargo_pkgs() {
	echo "Installing packages with cargo..."
	for pkg in "${cargo_pkgs[@]}"; do
		echo "Installing $pkg..."
		if command -v cargo &>/dev/null; then
			cargo install "$pkg"
		fi
	done
	echo
}

# install_node() {
# 	echo "Installing node via nvm..."
# 	if [[ $(command -v nvm) ]]; then
# 		nvm install --lts
# 		nvm use node
# 	fi
# 	echo
# }

# # Yarn package manager
# install_yarn() {
# 	echo "Installing yarn.."
# 	# arch
# 	if [ -f "/etc/arch-release" ]; then
# 		echo "installing yarn with pacman.."
# 		pacman -Sy yarn
# 	elif [ -f "/etc/fedora-release" ]; then
# 		# fedora / rhel
# 		echo "installing yarn with dnf.."
# 		curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
# 		sudo dnf -y install yarn
# 	else
# 		# debian/ubuntu
# 		echo "installing yarn with apt.."
# 		curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
# 		echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
# 		sudo apt update && sudo apt install yarn -y
# 	fi

# }

install_volta() {
	echo "Installing volta..."
	curl https://get.volta.sh | bash
	echo
}

# Starship Prompt
install_starship() {
	echo "Installing Starship prompt..."
	curl -fsSL https://starship.rs/install.sh | sh -s -- -y
	echo
}

# TODO: work out the kinks later
# setup_vnstat() {
# 	vnstat --iflist
# 	vnstat -u "<interface-name>"
# }

main() {
	install_cargo_pkgs
	install_volta
	# install_starship
}

main "$@"
