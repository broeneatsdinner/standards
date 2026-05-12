#!/usr/bin/env bash
# -----------------------------------------
# --    load-standards-initialization-prompt.sh    --
# -----------------------------------------
# description: Print and copy the standard project initialization prompt.
#
# This script extracts the first fenced text block from
# prompts/project-initialization.md, prints it to stdout, and copies it to the
# macOS clipboard.
#
# It can be run from the standards repository root or through a symlink from
# another directory.

set -u

# Resolve this script's real path, including symlinks, so relative repository
# paths work regardless of the current working directory.
script_path="${BASH_SOURCE[0]}"

while [[ -L "$script_path" ]]; do
	script_dir="$(cd -- "$(dirname -- "$script_path")" && pwd -P)"
	script_path="$(readlink -- "$script_path")"

	if [[ "$script_path" != /* ]]; then
		script_path="$script_dir/$script_path"
	fi
done

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "$script_path")" && pwd -P)"
readonly PROMPT_FILE="$SCRIPT_DIR/prompts/project-initialization.md"

# Print an error message to stderr and exit non-zero.
fail() {
	printf 'ERROR: %s\n' "$*" >&2
	exit 1
}

# Verify that a required command exists before continuing.
need_cmd() {
	command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

# Extract the first text fenced block from the project initialization prompt.
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
need_cmd pbcopy

[ -f "$PROMPT_FILE" ] || fail "Prompt file not found: $PROMPT_FILE"

prompt="$(extract_prompt)" || fail "Could not extract initialization prompt"

printf '# -------------------------------------\n'
printf '# --    actual prompt shown below    --\n'
printf '# -------------------------------------\n'
printf '\n'
printf '%s\n' "$prompt"
printf '%s\n' "$prompt" | pbcopy
printf '\n'
printf '# ----------------------------------------------------------\n'
printf '# -- Copied the above initialization prompt to clipboard. --\n'
printf '# ----------------------------------------------------------\n'
