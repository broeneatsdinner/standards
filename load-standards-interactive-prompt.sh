#!/usr/bin/env bash
# -------------------------------------------------
# --    load-standards-interactive-prompt.sh    --
# -------------------------------------------------
# description: Print and copy the interactive terminal session prompt.
#
# This script extracts the first fenced text block from
# prompts/interactive-terminal-session.md, prints it to stdout, and copies it
# to the macOS clipboard by default. Use --no-copy to print without copying.

set -u

copy_prompt=true

case "${1-}" in
	'')
		;;
	--no-copy)
		copy_prompt=false
		;;
	-h|--help)
		printf '%s\n' 'Usage: load-standards-interactive-prompt.sh [--no-copy]'
		printf '%s\n' 'Print and copy the interactive terminal session prompt.'
		exit 0
		;;
	*)
		printf 'ERROR: Unknown option: %s\n' "$1" >&2
		exit 2
		;;
esac

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

PROMPT_FILE="$SCRIPT_DIR/prompts/interactive-terminal-session.md"
readonly PROMPT_FILE

fail() {
	printf 'ERROR: %s\n' "$*" >&2
	exit 1
}

extract_prompt() {
	python3 - "$PROMPT_FILE" <<'PY'
from pathlib import Path
import sys

text = Path(sys.argv[1]).read_text()
start_marker = "```text\n"
end_marker = "\n```"
start = text.find(start_marker)

if start == -1:
    sys.exit("no opening ```text fence found")

start += len(start_marker)
end = text.find(end_marker, start)

if end == -1:
    sys.exit("no closing ```text fence found")

prompt = text[start:end].strip()

if not prompt:
    sys.exit("extracted prompt is empty")

print(prompt)
PY
}

command -v python3 >/dev/null 2>&1 || fail 'Required command not found: python3'
[[ -f "$PROMPT_FILE" ]] || fail "Prompt file not found: $PROMPT_FILE"

prompt="$(extract_prompt)" || fail 'Could not extract interactive prompt'
printf '%s\n' "$prompt"

if [[ "$copy_prompt" == true ]] && command -v pbcopy >/dev/null 2>&1; then
	printf '%s' "$prompt" | pbcopy
	printf '%s\n' 'Copied the interactive terminal session prompt to clipboard.'
elif [[ "$copy_prompt" == true ]]; then
	printf '%s\n' 'pbcopy not found; prompt was printed but not copied.'
fi
