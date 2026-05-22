#!/usr/bin/env bash
# ---------------------------------------------------------------
# --    load-google-sheets-rate-limit-conscious-workflow.sh    --
# ---------------------------------------------------------------
# description: Print and copy the Google Sheets rate-limit-conscious workflow prompt.
#
# This script extracts the first fenced text block from
# prompts/google-sheets-rate-limit-conscious-workflow.md, prints it to stdout,
# and copies it to the macOS clipboard when pbcopy is available.
#
# It can be run from the standards repository root or through a symlink from
# another directory.

set -u

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

PROMPT_FILE="$SCRIPT_DIR/prompts/google-sheets-rate-limit-conscious-workflow.md"
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

prompt="$(extract_prompt)" || fail "Could not extract Google Sheets workflow prompt"

print_banner "actual prompt shown below"
printf '\n'
printf '%s\n' "$prompt"
printf '\n'

if command -v pbcopy >/dev/null 2>&1; then
	printf '%s\n' "$prompt" | pbcopy
	print_banner "Copied the above Google Sheets workflow to clipboard."
else
	print_banner "pbcopy not found; prompt was printed but not copied."
fi
