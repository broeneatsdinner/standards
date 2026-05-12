#!/usr/bin/env bash
# ---------------------
# --    colors.sh    --
# ---------------------

# description: Provide shared terminal color definitions and color construction helpers.

# This file is meant to be sourced by other shell scripts, not run directly.

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	printf '%s\n' "This file is meant to be sourced, not run directly."
	exit 1
fi

# ansi_from_hex - convert a HEX color value to an ANSI truecolor foreground escape.
# usage:
#   ansi_from_hex "#00aaab"
ansi_from_hex() {
	local hex="$1"
	local r
	local g
	local b

	hex="${hex#"#"}"

	r="$(printf '%s' "$hex" | cut -c 1-2)"
	g="$(printf '%s' "$hex" | cut -c 3-4)"
	b="$(printf '%s' "$hex" | cut -c 5-6)"

	printf '\033[38;2;%d;%d;%dm' \
		"$((16#$r))" \
		"$((16#$g))" \
		"$((16#$b))"
}

# Palette tokens
ACID_BLUE_HEX="#00aaab"
ACID_GREEN_HEX="#55fd57"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
	RESET=$'\033[0m'
	BOLD=$'\033[1m'
	DIM=$'\033[2m'

	BLACK=$'\033[30m'
	RED=$'\033[31m'
	GREEN=$'\033[32m'
	YELLOW=$'\033[33m'
	BLUE=$'\033[34m'
	MAGENTA=$'\033[35m'
	CYAN=$'\033[36m'
	WHITE=$'\033[37m'

	BRIGHT_BLACK=$'\033[90m'
	BRIGHT_RED=$'\033[91m'
	BRIGHT_GREEN=$'\033[92m'
	BRIGHT_YELLOW=$'\033[93m'
	BRIGHT_BLUE=$'\033[94m'
	BRIGHT_MAGENTA=$'\033[95m'
	BRIGHT_CYAN=$'\033[96m'
	BRIGHT_WHITE=$'\033[97m'

	ACID_BLUE="$(ansi_from_hex "$ACID_BLUE_HEX")"
	ACID_GREEN="$(ansi_from_hex "$ACID_GREEN_HEX")"

	ICE="$BRIGHT_CYAN"
	MUTED="$DIM"
	SUCCESS="$GREEN"
	WARNING="$YELLOW"
	ERROR="$RED"
else
	RESET=""
	BOLD=""
	DIM=""

	BLACK=""
	RED=""
	GREEN=""
	YELLOW=""
	BLUE=""
	MAGENTA=""
	CYAN=""
	WHITE=""

	BRIGHT_BLACK=""
	BRIGHT_RED=""
	BRIGHT_GREEN=""
	BRIGHT_YELLOW=""
	BRIGHT_BLUE=""
	BRIGHT_MAGENTA=""
	BRIGHT_CYAN=""
	BRIGHT_WHITE=""

	ACID_BLUE=""
	ACID_GREEN=""

	ICE=""
	MUTED=""
	SUCCESS=""
	WARNING=""
	ERROR=""
fi
