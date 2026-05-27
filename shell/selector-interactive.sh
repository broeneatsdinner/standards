# -----------------------------------
# --    selector-interactive.sh    --
# -----------------------------------
# description: Provide arrow-key terminal selector helpers.
#
# This file is meant to be sourced by Bash or Zsh scripts, not run directly.
#
# It provides the richer keyboard-navigation selector pattern for interactive
# terminal workflows.

_selector_interactive_is_direct_execution() {
	if [[ -n "${ZSH_VERSION:-}" ]]; then
		[[ ":${ZSH_EVAL_CONTEXT:-}:" != *:file:* ]]
	elif [[ -n "${BASH_VERSION:-}" ]]; then
		[[ "${BASH_SOURCE[0]}" == "$0" ]]
	else
		return 1
	fi
}

if _selector_interactive_is_direct_execution; then
	printf '%s\n' "This file is meant to be sourced, not run directly."
	exit 1
fi

unset -f _selector_interactive_is_direct_execution

# Render a list of options selected with Up, Down, Enter, q, Q, or Escape.
select_option() {
	local ESC
	ESC=$(printf '\033')
	cursor_blink_on()  { printf '%s' "${ESC}[?25h"; }
	cursor_blink_off() { printf '%s' "${ESC}[?25l"; }
	cursor_up()        { printf '%s' "${ESC}[$1A"; }
	clear_line()       { printf '%s' "${ESC}[2K"; }
	print_option()     { printf '   %s ' "$1"; }
	print_selected()   { printf '  %s %s %s' "${ESC}[7m" "$1" "${ESC}[27m"; }
	selector_cleanup() {
		cursor_blink_on
		printf '\n'
	}
	# shellcheck disable=SC2329
	selector_interrupt() {
		selector_cleanup
		trap - INT
		return 130
	}
	key_input() {
		local key
		local rest

		if [[ -n "${ZSH_VERSION:-}" ]]; then
			IFS= read -r -s -k 1 key </dev/tty

			if [[ "$key" == "$ESC" ]]; then
				IFS= read -r -s -t 0.1 -k 2 rest </dev/tty || rest=""
				key="${key}${rest}"
			fi
		else
			read -r -s -n3 key 2>/dev/null >&2
		fi

		if [[ "$key" == "${ESC}[A" ]]; then printf '%s\n' up; fi
		if [[ "$key" == "${ESC}[B" ]]; then printf '%s\n' down; fi
		if [[ "$key" == "q" || "$key" == "Q" ]]; then printf '%s\n' cancel; fi
		if [[ "$key" == "$ESC" ]]; then printf '%s\n' cancel; fi
		if [[ -z "$key" || "$key" == $'\n' || "$key" == $'\r' ]]; then printf '%s\n' enter; fi
	}

	for opt; do
		printf '\n'
	done

	# Keep the cursor visible if the selector is interrupted during input.
	trap selector_interrupt INT
	cursor_blink_off

	local option_count=$#
	local selected=0
	local idx
	local opt

	while true; do
		# Redraw reserved option lines without asking the terminal for cursor
		# position. ESC[6n responses can leak visibly in real terminals.
		cursor_up "$option_count"
		idx=0
		for opt; do
			printf '\r'
			clear_line
			if [[ $idx -eq $selected ]]; then
				print_selected "$opt"
			else
				print_option "$opt"
			fi
			printf '\n'
			((idx++))
		done

		case "$(key_input)" in
			enter)
				break
				;;
			cancel)
				selected=130
				break
				;;
			up)
				((selected--))
				if [[ $selected -lt 0 ]]; then
					selected=$(($# - 1))
				fi
				;;
			down)
				((selected++))
				if [[ $selected -ge $# ]]; then
					selected=0
				fi
				;;
		esac
	done

	selector_cleanup
	trap - INT

	return "$selected"
}

# Print the selected option index while rendering the menu on stderr.
select_opt() {
	select_option "$@" 1>&2
	local result=$?
	printf '%s\n' "$result"
	return "$result"
}

# Set keyboard_select_response to the selected option value.
keyboard_select() {
	local options=("$@")
	local selected
	local selected_index
	local selected_status

	selected="$(select_opt "${options[@]}")"
	selected_status=$?
	if [[ $selected_status -eq 130 ]]; then
		return 130
	fi

	if [[ -n "${ZSH_VERSION:-}" ]]; then
		selected_index=$((selected + 1))
	else
		selected_index=$selected
	fi

	# shellcheck disable=SC2034
	keyboard_select_response="${options[$selected_index]}"
	return 0
}
