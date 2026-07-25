#!/usr/bin/env bash
# -------------------------------------------------
# --    load-standards-interactive-prompt.sh    --
# -------------------------------------------------
# description: Print and copy the interactive terminal session prompt.
#
# This script extracts the first fenced text block from
# prompts/interactive-terminal-session.md, fills in the current repository and
# next tmux session name, prints it to stdout, and copies it by default. It then
# launches that visible session. Use --no-copy to print without copying.

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
		printf '%s\n' 'Print the hydrated prompt, copy it by default, and start its tmux session.'
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

if ! repository_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
	printf '%s\n' 'ERROR: Run this command from a Git repository root.' >&2
	exit 1
fi

repository_root="$(cd "$repository_root" && pwd -P)" || exit 1
current_directory="$(pwd -P)" || exit 1

if [[ "$current_directory" != "$repository_root" ]]; then
	printf '%s\n' 'ERROR: Run this command from the Git repository root.' >&2
	printf '%s\n' "Repository root: $repository_root" >&2
	exit 1
fi

session_name="$(/bin/zsh -fc 'source "$HOME/.dotfiles/functions"; cd "$1"; chatgpt --session-name' zsh "$repository_root")" || {
	printf '%s\n' 'ERROR: Could not determine the next chatgpt tmux session name.' >&2
	exit 1
}

export INTERACTIVE_TMUX_SESSION="$session_name"
export INTERACTIVE_REPOSITORY_ROOT="$repository_root"
export INTERACTIVE_STANDARDS_REPOSITORY="$SCRIPT_DIR"

fail() {
	printf 'ERROR: %s\n' "$*" >&2
	exit 1
}

extract_prompt() {
	python3 - "$PROMPT_FILE" <<'PY'
from pathlib import Path
import os
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
prompt = prompt.replace("{{TMUX_SESSION}}", os.environ["INTERACTIVE_TMUX_SESSION"])
prompt = prompt.replace("{{REPOSITORY_ROOT}}", os.environ["INTERACTIVE_REPOSITORY_ROOT"])
prompt = prompt.replace("{{STANDARDS_REPOSITORY}}", os.environ["INTERACTIVE_STANDARDS_REPOSITORY"])

if not prompt:
    sys.exit("extracted prompt is empty")

print(prompt)
PY
}

command -v python3 >/dev/null 2>&1 || fail 'Required command not found: python3'
[[ -f "$PROMPT_FILE" ]] || fail "Prompt file not found: $PROMPT_FILE"

prompt="$(extract_prompt)" || fail 'Could not extract interactive prompt'
printf '%s\n' "Starting tmux session: $session_name"

if [[ "$copy_prompt" == false ]]; then
	export CHATGPT_SKIP_BOOTSTRAP_CLIPBOARD=true
fi

exec env CHATGPT_BOOTSTRAP_PROMPT="$prompt" /bin/zsh -fc 'source "$HOME/.dotfiles/functions"; cd "$1"; chatgpt' zsh "$repository_root"
