#!/usr/bin/env bash
# ----------------------------
# --    terminal-text.sh    --
# ----------------------------

# description: Provide ANSI-aware visible-width and padding helpers for colored terminal output.

# This file is meant to be sourced by other shell scripts, not run directly.
# Color definitions and color construction belong in shell/colors.sh.

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	printf '%s\n' "This file is meant to be sourced, not run directly."
	exit 1
fi

# strip_ansi - remove ANSI escape sequences from terminal-formatted text.
# usage:
#   printf '%s' "$colored_text" | strip_ansi
strip_ansi() {
	perl -pe 's/\e\[[0-9;?]*[ -\/]*[@-~]//g'
}

# visible_length - print the display length of a string after removing ANSI escapes.
# usage:
#   visible_length "$colored_text"
visible_length() {
	local text="$1"

	printf '%s' "$text" | strip_ansi | awk '{ print length }'
}

# pad_right_visible - print a string padded to a target visible width.
# usage:
#   pad_right_visible "$colored_label" 36
pad_right_visible() {
	local text="$1"
	local width="$2"
	local visible
	local padding

	visible="$(visible_length "$text")"
	padding=$((width - visible))

	printf '%s' "$text"

	if (( padding > 0 )); then
		printf '%*s' "$padding" ''
	fi
}

# print_padded_line - print a label and value with visible-width-aware padding.
# usage:
#   print_padded_line "$colored_label" "$value" 36
print_padded_line() {
	local label="$1"
	local value="$2"
	local width="$3"

	pad_right_visible "$label" "$width"
	printf '%s\n' "$value"
}
