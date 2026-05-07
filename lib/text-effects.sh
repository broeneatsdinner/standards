#!/usr/bin/env bash
# ------------------------
# --    text-effects    --
# ------------------------

# Shared terminal text-effect helpers.
#
# This file is meant to be sourced by other shell scripts, not run directly.

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	printf '%s\n' "This file is meant to be sourced, not run directly."
	exit 1
fi

type_text() {
	local text="${1:-}"
	local delay="${2:-0.02}"
	local i

	for ((i = 0; i < ${#text}; i++)); do
		printf '%s' "${text:i:1}"
		sleep "$delay"
	done

	printf '\n'
}

print_rule() {
	local char="${1:--}"
	local width="${2:-80}"

	printf '%*s\n' "$width" '' | tr ' ' "$char"
}
