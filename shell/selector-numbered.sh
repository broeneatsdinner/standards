# --------------------------------
# --    selector-numbered.sh    --
# --------------------------------
# description: Provide numbered-choice terminal selector helpers.
#
# This file is meant to be sourced by Bash or Zsh scripts, not run directly.
#
# It provides the simpler numbered-choice selector pattern for scripts that do
# not need arrow-key navigation.

_selector_numbered_is_direct_execution() {
	if [[ -n "${ZSH_VERSION:-}" ]]; then
		[[ ":${ZSH_EVAL_CONTEXT:-}:" != *:file:* ]]
	elif [[ -n "${BASH_VERSION:-}" ]]; then
		[[ "${BASH_SOURCE[0]}" == "$0" ]]
	else
		return 1
	fi
}

if _selector_numbered_is_direct_execution; then
	printf '%s\n' "This file is meant to be sourced, not run directly."
	exit 1
fi

unset -f _selector_numbered_is_direct_execution

select_from_list() {
	local prompt="${1:-Select an option}"
	shift

	local options=("$@")
	local option
	local index=1
	local selection

	if [[ "${#options[@]}" -eq 0 ]]; then
		return 1
	fi

	printf '%s\n' "$prompt" >&2

	for option in "${options[@]}"; do
		printf '%2d) %s\n' "$index" "$option" >&2
		((index++))
	done

	printf '%s' "> " >&2
	IFS= read -r selection

	if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
		return 1
	fi

	if (( selection < 1 || selection > ${#options[@]} )); then
		return 1
	fi

	if [[ -n "${ZSH_VERSION:-}" ]]; then
		printf '%s\n' "${options[$selection]}"
	else
		printf '%s\n' "${options[$((selection - 1))]}"
	fi
}
