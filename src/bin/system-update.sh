#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

alias have='>/dev/null 2>&1 command -v'

pm-apt() {
	>/dev/null 2>&1 command -v apt || return
	sudo apt update
	sudo apt full-upgrade --assume-yes
	sudo apt autoremove --purge
}

pm-flatpak() {
	>/dev/null 2>&1 command -v flatpak || return
	flatpak update --assumeyes
	flatpak uninstall --assumeyes --unused
}

pm-homebrew() {
	>/dev/null 2>&1 command -v brew || return
	brew update
	brew upgrade --yes
	brew autoremove
	brew cleanup --prune=all --scrub
}

pm-nix-root() {
	>/dev/null 2>&1 command -v nix || return
	sudo -i nix upgrade-nix

	should_start=0
	update_unit() {
		local src=$1
		local dst=$2
		if [[ -L "${dst}" || "${src}" -nt "${dst}" ]]; then
			sudo systemctl stop "$(basename "${dst}")"
			sudo rm "${dst}"
			sudo cp "${src}" "${dst}"
			sudo chmod 0644 "${dst}"
			should_start=1
		fi
	}

	update_unit \
		/nix/var/nix/profiles/default/lib/systemd/system/nix-daemon.socket \
		/etc/systemd/system/nix-daemon.socket

	update_unit \
		/nix/var/nix/profiles/default/lib/systemd/system/nix-daemon.service \
		/etc/systemd/system/nix-daemon.service

	if [[ $should_start -eq 1 ]]; then
		sudo systemctl daemon-reload
		sudo systemctl start nix-daemon.socket nix-daemon.service
	fi

	sudo -i nix-collect-garbage
}

pm-nix-user() {
	>/dev/null 2>&1 command -v nix || return
	nix profile upgrade --all
	nix-collect-garbage
}

pm-snap() {
	>/dev/null 2>&1 command -v snap || return
	sudo snap refresh
}

pm-software-update() {
	>/dev/null 2>&1 command -v softwareupdate || return
	softwareupdate --install --all
}

run-package-manager() {
	local package_manager="$1"
	echo "*** PACKAGE MANAGER ${package_manager} ***"
	"pm-$1"
	echo
}

readarray -t PACKAGE_MANAGERS < <(
	# shellcheck disable=SC2312
	awk -F 'pm-|[(]' '/^pm-.*\(\) \{$/ {print $2}' "${BASH_SOURCE[0]}"
)

case "${1:-ALL}" in
ALL)
	for package_manager in "${PACKAGE_MANAGERS[@]}"; do
		run-package-manager "${package_manager}"
	done
	;;

*)
	available=$(
		IFS=' '
		echo "${PACKAGE_MANAGERS[*]}"
	)

	# shellcheck disable=SC2076
	if [[ " ${available} " =~ " $1 " ]]; then
		run-package-manager "$1"
	else
		help=$(
			IFS='|'
			echo "ALL|${PACKAGE_MANAGERS[*]}"
		)
		>&2 echo "Usage: ${BASH_SOURCE[0]} [${help}]"
		exit 1
	fi
	;;
esac
