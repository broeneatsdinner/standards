#!/usr/bin/env bash
# ---------------------------------------------------
# --    load-standards-initialization-prompt.sh    --
# ---------------------------------------------------
# description: Print the standard project initialization prompt.
#
# This script extracts the first fenced text block from
# prompts/project-initialization.md and prints it to stdout. Clipboard copying
# is opt-in with --copy for standalone or disconnected sessions.
#
# It can be run from the standards repository root or through a symlink from
# another directory.

set -u

copy_prompt=false

case "${1-}" in
	'') ;;
	--copy) copy_prompt=true ;;
	-h|--help)
		printf '%s\n' 'Usage: load-standards-initialization-prompt.sh [--copy]'
		exit 0
		;;
	*)
		printf 'ERROR: Unknown option: %s\n' "$1" >&2
		exit 2
		;;
esac

# Resolve this script's real path, including symlinks, so relative repository
# paths work regardless of the current working directory.
script_path="${BASH_SOURCE[0]}"

while [[ -L "$script_path" ]]; do
	script_dir="$(cd -P "$(dirname "$script_path")" && pwd)"
	script_path="$(readlink "$script_path")"

	if [[ "$script_path" != /* ]]; then
		script_path="$script_dir/$script_path"
	fi
done

SCRIPT_DIR="$(cd -P "$(dirname "$script_path")" && pwd)"
readonly SCRIPT_DIR

PROMPT_FILE="$SCRIPT_DIR/prompts/project-initialization.md"
readonly PROMPT_FILE

# Print an error message to stderr and exit non-zero.
fail() {
	printf 'ERROR: %s\n' "$*" >&2
	exit 1
}

# Verify that a required command exists before continuing.
need_cmd() {
	command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

# Print a precise three-line terminal banner.
print_banner() {
	local message="$1"
	local middle="# --    $message    --"
	local dash_count
	local border

	dash_count=$((${#middle} - 2))
	border="# $(printf '%*s' "$dash_count" '' | tr ' ' '-')"

	printf '%s\n%s\n%s\n' "$border" "$middle" "$border"
}

# Extract the first text fenced block from the prompt file.
extract_prompt() {
	python3 - "$PROMPT_FILE" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])

try:
	text = path.read_text()
except FileNotFoundError:
	sys.exit(f"prompt file not found: {path}")

start_marker = "```text\n"
end_marker = "\n```"

start = text.find(start_marker)

if start == -1:
	sys.exit("no opening ```text fence found")

start += len(start_marker)
end = text.find(end_marker, start)

if end == -1:
	sys.exit("no closing fence found after first ```text fence")

prompt = text[start:end].strip()

if not prompt:
	sys.exit("extracted prompt is empty")

print(prompt)
PY
}

need_cmd python3

[ -f "$PROMPT_FILE" ] || fail "Prompt file not found: $PROMPT_FILE"

prompt="$(extract_prompt)" || fail "Could not extract initialization prompt"

print_banner "actual prompt shown below"
printf '\n'
printf '%s\n' "$prompt"
printf '\n'

if [[ "$copy_prompt" == true ]] && command -v pbcopy >/dev/null 2>&1; then
	printf '%s\n' "$prompt" | pbcopy
	print_banner "Copied the above initialization prompt to clipboard."
elif [[ "$copy_prompt" == true ]]; then
	print_banner "pbcopy not found; prompt was printed but not copied."
else
	print_banner "Prompt shown above; clipboard copy is disabled by default."
fi
