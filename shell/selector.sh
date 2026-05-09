#!/usr/bin/env bash
# -----------------------
# --    selector.sh    --
# -----------------------

# Shared terminal selector helpers.
#
# This file is meant to be sourced by other shell scripts, not run directly.

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	printf '%s\n' "This file is meant to be sourced, not run directly."
	exit 1
fi

select_from_list() {
	local prompt="${1:-Select an option}"
	shift

	local options=("$@")
	local option
	local index=1

	if [[ "${#options[@]}" -eq 0 ]]; then
		return 1
	fi

	printf '%s\n' "$prompt"

	for option in "${options[@]}"; do
		printf '%2d) %s\n' "$index" "$option"
		((index++))
	done

	printf '%s' "> "
	read -r selection

	if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
		return 1
	fi

	if (( selection < 1 || selection > ${#options[@]} )); then
		return 1
	fi

	printf '%s\n' "${options[selection - 1]}"
}
