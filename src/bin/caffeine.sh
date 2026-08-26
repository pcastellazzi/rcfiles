#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

caffeine() {
	local action="${1}"
	shift 1

	local options=(
		--schemadir "${HOME}/.local/share/gnome-shell/extensions/caffeine@patapon.info/schemas/"
		"${action}"
		org.gnome.shell.extensions.caffeine cli-toggle
	)
	gsettings "${options[@]}" "$@"
}

case "${1:-status}" in
status) caffeine get ;;
on | true) caffeine set true ;;
off | false) caffeine set false ;;
*)
	>&2 echo "[ERR] Usage: $0 <status|on|off>"
	exit 1
	;;
esac
