#!/usr/bin/env bash
# ----------------------
# --    loaders.sh    --
# ----------------------

# Shared loader and spinner helpers.
#
# This file is meant to be sourced by other shell scripts, not run directly.

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	printf '%s\n' "This file is meant to be sourced, not run directly."
	exit 1
fi

loader_pid=""

loader_start() {
	local message="${1:-Working}"
	local delay="${2:-0.1}"
	local frames='-\|/'

	if [[ ! -t 1 ]]; then
		return 0
	fi

	(
		local i=0
		while true; do
			printf '\r%s %s' "$message" "${frames:i++%${#frames}:1}"
			sleep "$delay"
		done
	) &

	loader_pid="$!"
}

loader_stop() {
	if [[ -n "${loader_pid:-}" ]]; then
		kill "$loader_pid" 2>/dev/null || true
		wait "$loader_pid" 2>/dev/null || true
		loader_pid=""
	fi

	if [[ -t 1 ]]; then
		printf '\r\033[K'
	fi
}
