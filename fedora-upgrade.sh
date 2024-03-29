#!/bin/env bash
#
set -eo pipefail

declare CURRENT_VER

dependencies=("jq" "curl")

installDependencies() {
    
    if  ! hash dnf 2>/dev/null; then
		echo 'script should only be run on fedora or a fedora derived distro'
		exit 1
    fi

    echo 'installing dependencies...'
	for pkg in "${dependencies[@]}"; do
		if ! hash "$pkg" 2>/dev/null; then
			echo "installing $pkg..."
			sudo dnf install "$pkg" -y
		fi
	done

	echo 'all dependencies installed!'
}

# get latest fedora release number
getLatestReleaseVersion() {
	echo 'getting latest fedora release number...'
	LATEST_VER="$(curl -s "https://getfedora.org/releases.json" |
		jq -r '[.[].version | select(test("^\\d*$"))] | max')"
}

#get the current release number
getCurrentReleaseVersion() {
	if [[ -f /etc/fedora-release ]]; then
		echo 'getting running version number...'

		source /etc/os-release

		CURRENT_VER=$VERSION_ID

		# CURRENT_VER=$(grep -i version_id /etc/os-release | cut -d "=" -f 2)
		# echo running "$CURRENT_VER"

		# LATEST_VER=$((CURRENT_VER + 1))
		# echo upgrading to "$LATEST_VER"
	else
		echo 'script should only be run on fedora or a fedora derived distro'
		exit 1
	fi
}

# update your current system
updateCurrentSystem() {
	echo 'upgrading current release...'
	sudo dnf upgrade --refresh -y
}

# install dnf plugin system
installUpgradeDependencies() {
	echo 'installing dnf upgrade plugin...'
	sudo dnf install dnf-plugin-system-upgrade -y
}
# download the updated packages
installUpgradedPackages() {
	echo "downloading packages for F$LATEST_VER.."
	sudo dnf system-upgrade download --releasever="$LATEST_VER" -y
}

# trigger the upgrade process
triggerUpgrade() {
    echo "upgrading to F$LATEST_VER from F$CURRENT_VER..."
	sudo dnf system-upgrade reboot -y
}

main() {
	installDependencies
	getCurrentReleaseVersion
	getLatestReleaseVersion

	if [ "$CURRENT_VER" -eq "$LATEST_VER" ]; then
		echo 'you are already on the latest version of fedora'
		echo 'exiting...'
		exit
	fi

	updateCurrentSystem
	installUpgradeDependencies
	installUpgradedPackages
	triggerUpgrade
}

main "$@"
