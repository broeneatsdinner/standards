#!/usr/bin/env bash
# ------------------
# --    colors    --
# ------------------

# Shared terminal color definitions.
#
# This file is meant to be sourced by other shell scripts, not run directly.

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	printf '%s\n' "This file is meant to be sourced, not run directly."
	exit 1
fi

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

	ICE=""
	MUTED=""
	SUCCESS=""
	WARNING=""
	ERROR=""
fi
