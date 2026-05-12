#!/usr/bin/env bash
# ----------------------
# --    headers.sh    --
# ----------------------

# description: Provide shared graphical header helpers.

# This file is meant to be sourced by other shell scripts, not run directly.

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	printf '%s\n' "This file is meant to be sourced, not run directly."
	exit 1
fi

print_header() {
	local title="${1:-script}"
	local title_text="--    $title    --"
	local width="${#title_text}"
	local line

	line="$(printf '%*s' "$width" '' | tr ' ' '-')"

	printf '# %s\n' "$line"
	printf '# %s\n' "$title_text"
	printf '# %s\n' "$line"
}
