#!/usr/bin/env bash
# -------------------------
# --    color-wash.sh    --
# -------------------------
# shellcheck shell=bash

# description: Provide a reusable terminal gradient-wash text primitive.

if [ -z "${BASH_VERSION:-}" ]; then
	printf '%s\n' "color-wash.sh requires bash." >&2
	# shellcheck disable=SC2317
	return 1 2>/dev/null || exit 1
fi

# Precomputed center cadence. Values are scaled to the target text width at
# render time so the same soft pass works for short status tokens and phrases.
COLOR_WASH_CENTERS=(
	-6 -5 -4 -3 -2 -1
	0 0 1 1 2 3 4 5 6
	7 7 8 9 10 11 12
)
COLOR_WASH_CENTER_MIN=-6
COLOR_WASH_CENTER_MAX=12
COLOR_WASH_EDGE_PADDING=6

_color_wash_is_direct_execution() {
	[[ "${BASH_SOURCE[0]}" == "$0" ]]
}

_color_wash_enabled() {
	[[ -z "${NO_COLOR:-}" ]] &&
		[[ -n "${FORCE_COLOR:-}" || -t 1 ]]
}

_color_wash_is_identifier() {
	[[ "$1" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
}

_color_wash_is_hex() {
	[[ "$1" =~ ^#?[[:xdigit:]]{6}$ ]]
}

_color_wash_load_colors() {
	local source_path="${BASH_SOURCE[0]}"
	local script_dir
	local colors_file

	if [[ -n "${_COLOR_WASH_COLORS_LOADED:-}" ]]; then
		return 0
	fi

	script_dir="${source_path%/*}"
	if [[ "$script_dir" == "$source_path" ]]; then
		script_dir="."
	fi
	script_dir="$(cd -- "$script_dir" && pwd)"
	colors_file="${script_dir}/colors.sh"

	if [[ -f "$colors_file" ]]; then
		# shellcheck source=shell/colors.sh disable=SC1091
		source "$colors_file"
	fi

	_COLOR_WASH_COLORS_LOADED=1
}

_color_wash_ansi_from_hex() {
	local hex="${1#"#"}"

	printf '\033[38;2;%d;%d;%dm' \
		"$((16#${hex:0:2}))" \
		"$((16#${hex:2:2}))" \
		"$((16#${hex:4:2}))"
}

_color_wash_array_length() {
	local array_name="$1"

	_color_wash_is_identifier "$array_name" || return 1
	eval "printf '%s\n' \"\${#${array_name}[@]}\""
}

_color_wash_array_value() {
	local array_name="$1"
	local index="$2"

	_color_wash_is_identifier "$array_name" || return 1
	[[ "$index" =~ ^[0-9]+$ ]] || return 1
	eval "printf '%s\n' \"\${${array_name}[${index}]}\""
}

_color_wash_array_exists() {
	local array_name="$1"
	local declaration

	_color_wash_is_identifier "$array_name" || return 1
	declaration="$(declare -p "$array_name" 2>/dev/null)" || return 1
	[[ "$declaration" == declare\ -a* || "$declaration" == declare\ -ax* ]]
}

_color_wash_var_value() {
	local var_name="$1"

	_color_wash_is_identifier "$var_name" || return 1
	eval "printf '%s\n' \"\${${var_name}:-}\""
}

_color_wash_palette_for_token() {
	local token="$1"
	local base_token="$1"
	local family_token
	local palette_name

	_color_wash_load_colors
	_color_wash_is_identifier "$token" || return 1

	if [[ "$token" == *_WASH ]]; then
		if _color_wash_array_exists "$token"; then
			printf '%s\n' "$token"
			return 0
		fi

		base_token="${token%_WASH}"
	fi

	palette_name="${base_token}_WASH"
	if _color_wash_array_exists "$palette_name"; then
		printf '%s\n' "$palette_name"
		return 0
	fi

	family_token="${base_token%%_*}"
	palette_name="${family_token}_WASH"
	if _color_wash_array_exists "$palette_name"; then
		printf '%s\n' "$palette_name"
		return 0
	fi

	return 1
}

_color_wash_hex_for_token() {
	local token="$1"
	local base_token="$1"
	local hex_var
	local hex

	_color_wash_load_colors

	if _color_wash_is_hex "$token"; then
		hex="${token#"#"}"
		printf '#%s\n' "$hex"
		return 0
	fi

	_color_wash_is_identifier "$token" || return 1
	if [[ "$token" == *_WASH ]]; then
		base_token="${token%_WASH}"
	fi

	hex_var="${base_token}_HEX"
	hex="$(_color_wash_var_value "$hex_var")"
	if _color_wash_is_hex "$hex"; then
		printf '%s\n' "$hex"
		return 0
	fi

	return 1
}

_color_wash_center_for_frame() {
	local text_length="$1"
	local frame_index="$2"
	local frame_count="${#COLOR_WASH_CENTERS[@]}"
	local center_index
	local raw_center
	local source_span
	local target_max
	local target_span

	if (( frame_count == 0 )); then
		printf '%s\n' 0
		return 0
	fi

	center_index=$((frame_index % frame_count))
	if (( center_index < 0 )); then
		center_index=$((center_index + frame_count))
	fi

	raw_center="${COLOR_WASH_CENTERS[center_index]}"
	source_span=$((COLOR_WASH_CENTER_MAX - COLOR_WASH_CENTER_MIN))
	target_max=$((text_length - 1 + COLOR_WASH_EDGE_PADDING))
	target_span=$((target_max - COLOR_WASH_CENTER_MIN))

	printf '%s\n' "$((COLOR_WASH_CENTER_MIN + ((raw_center - COLOR_WASH_CENTER_MIN) * target_span) / source_span))"
}

color_wash_solid() {
	local token="$1"
	local text="$2"
	local color_hex
	local reset=$'\033[0m'

	if [[ -z "$text" ]]; then
		return 0
	fi

	if ! _color_wash_enabled; then
		printf '%s' "$text"
		return 0
	fi

	color_hex="$(_color_wash_hex_for_token "$token")" || {
		printf '%s' "$text"
		return 0
	}

	printf '%b%s%b' "$(_color_wash_ansi_from_hex "$color_hex")" "$text" "$reset"
}

color_wash() {
	local token="$1"
	local text="$2"
	local frame_index="${3:-0}"
	local reset=$'\033[0m'
	local palette_name=""
	local palette_length=0
	local solid_hex=""
	local length
	local center
	local i
	local j
	local distance
	local ch
	local palette_index
	local hex
	local ansi
	local -a ansi_palette=()

	if [[ -z "$text" ]]; then
		return 0
	fi

	if ! _color_wash_enabled; then
		printf '%s' "$text"
		return 0
	fi

	case "$frame_index" in
		''|*[!0-9-]*)
			frame_index=0
			;;
	esac

	_color_wash_load_colors
	if palette_name="$(_color_wash_palette_for_token "$token")"; then
		palette_length="$(_color_wash_array_length "$palette_name")"
		if (( palette_length <= 0 )); then
			printf '%s' "$text"
			return 0
		fi

		for ((j = 0; j < palette_length; j++)); do
			hex="$(_color_wash_array_value "$palette_name" "$j")"
			ansi_palette[j]="$(_color_wash_ansi_from_hex "$hex")"
		done
	elif solid_hex="$(_color_wash_hex_for_token "$token")"; then
		ansi_palette[0]="$(_color_wash_ansi_from_hex "$solid_hex")"
		palette_length=1
	else
		printf '%s' "$text"
		return 0
	fi

	length="${#text}"
	center="$(_color_wash_center_for_frame "$length" "$frame_index")"

	for ((i = 0; i < length; i++)); do
		ch="${text:i:1}"
		distance=$((i - center))
		if (( distance < 0 )); then
			distance=$((-distance))
		fi

		palette_index="$distance"
		if (( palette_index >= palette_length )); then
			palette_index=$((palette_length - 1))
		fi

		ansi="${ansi_palette[palette_index]}"
		printf '%b%s%b' "$ansi" "$ch" "$reset"
	done
}

_color_wash_sleep_ms() {
	local milliseconds="$1"
	local seconds
	local remainder
	local delay

	[[ "$milliseconds" =~ ^[0-9]+$ ]] || milliseconds=80
	if (( milliseconds <= 0 )); then
		return 0
	fi

	seconds=$((milliseconds / 1000))
	remainder=$((milliseconds % 1000))
	printf -v delay '%d.%03d' "$seconds" "$remainder"
	sleep "$delay"
}

_color_wash_hide_cursor() {
	printf '\033[?25l'
}

_color_wash_show_cursor() {
	printf '\033[?25h'
}

_color_wash_render_demo_frame() {
	local token="$1"
	local text="$2"
	local frame="$3"

	if [[ -z "${NO_COLOR:-}" ]]; then
		local FORCE_COLOR=1

		color_wash "$token" "$text" "$frame"
	else
		color_wash "$token" "$text" "$frame"
	fi
}

_color_wash_usage() {
	printf '%s\n' "usage:"
	printf '%s\n' "  color-wash.sh [--solid] TEXT TOKEN [speed=MS] [cycles=N] [frames=N] [pause=MS]"
	printf '%s\n' "examples:"
	printf '%s\n' "  color-wash.sh \"Working...\" ACID_BLUE speed=80 cycles=3 pause=400"
	printf '%s\n' "  color-wash.sh --solid \"22\" ACID_BLUE"
}

_color_wash_main() {
	local solid=0
	local text="${1:-Working...}"
	local token="${2:-ACID_BLUE}"
	local speed=80
	local cycles=1
	local frames=""
	local pause=0
	local frame_count="${#COLOR_WASH_CENTERS[@]}"
	local total_frames
	local cycle
	local frame
	local frame_output
	local arg

	case "${1:-}" in
		-h|--help)
			_color_wash_usage
			return 0
			;;
		--solid)
			solid=1
			text="${2:-}"
			token="${3:-ACID_BLUE}"
			if (( $# >= 3 )); then
				shift 3
			else
				shift "$#"
			fi
			;;
		*)
			if (( $# >= 2 )); then
				shift 2
			else
				shift "$#"
			fi
			;;
	esac

	for arg in "$@"; do
		case "$arg" in
			speed=*)
				speed="${arg#speed=}"
				;;
			cycles=*)
				cycles="${arg#cycles=}"
				;;
			frames=*)
				frames="${arg#frames=}"
				;;
			pause=*)
				pause="${arg#pause=}"
				;;
			*)
				printf 'color-wash.sh: unknown option: %s\n' "$arg" >&2
				_color_wash_usage >&2
				return 2
				;;
		esac
	done

	if [[ "$solid" == 1 ]]; then
		color_wash_solid "$token" "$text"
		printf '\n'
		return 0
	fi

	[[ "$cycles" =~ ^[0-9]+$ ]] || cycles=1
	[[ "$frames" =~ ^[0-9]+$ ]] || frames=""
	[[ "$pause" =~ ^[0-9]+$ ]] || pause=0

	if [[ -n "$frames" ]]; then
		total_frames="$frames"
	elif (( cycles > 0 )); then
		total_frames="$frame_count"
	else
		total_frames=0
	fi

	if (( total_frames <= 0 )); then
		color_wash "$token" "$text" 0
		printf '\n'
		return 0
	fi

	_color_wash_hide_cursor
	trap '_color_wash_show_cursor' EXIT
	trap '_color_wash_show_cursor; trap - EXIT; exit 130' INT
	trap '_color_wash_show_cursor; trap - EXIT; exit 143' TERM

	printf '\r\033[K'
	if [[ -n "$frames" ]]; then
		for ((frame = 0; frame < total_frames; frame++)); do
			frame_output="$(_color_wash_render_demo_frame "$token" "$text" "$frame")"
			printf '\r%b' "$frame_output"
			_color_wash_sleep_ms "$speed"
		done

		frame_output="$(_color_wash_render_demo_frame "$token" "$text" "$((total_frames - 1))")"
	else
		for ((cycle = 0; cycle < cycles; cycle++)); do
			for ((frame = 0; frame < frame_count; frame++)); do
				frame_output="$(_color_wash_render_demo_frame "$token" "$text" "$frame")"
				printf '\r%b' "$frame_output"
				_color_wash_sleep_ms "$speed"
			done

			if (( pause > 0 && cycle < cycles - 1 )); then
				_color_wash_sleep_ms "$pause"
			fi
		done

		frame_output="$(_color_wash_render_demo_frame "$token" "$text" "$((frame_count - 1))")"
	fi

	printf '\r%b\n' "$frame_output"
	_color_wash_show_cursor
	trap - EXIT INT TERM
}

if _color_wash_is_direct_execution; then
	_color_wash_main "$@"
fi
