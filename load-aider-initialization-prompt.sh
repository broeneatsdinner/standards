#!/usr/bin/env bash
# -------------------------------------------------
# --    load-aider-initialization-prompt.sh    --
# -------------------------------------------------
# description: Print and copy the Aider project initialization prompt.

set -u

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

BASE_LOADER="$SCRIPT_DIR/load-standards-initialization-prompt.sh"
readonly BASE_LOADER

fail() {
	printf 'ERROR: %s\n' "$*" >&2
	exit 1
}

print_banner() {
	local message="$1"
	local middle="# --    $message    --"
	local dash_count
	local border

	dash_count=$((${#middle} - 2))
	border="# $(printf '%*s' "$dash_count" '' | tr ' ' '-')"

	printf '%s\n%s\n%s\n' "$border" "$middle" "$border"
}

[ -x "$BASE_LOADER" ] || fail "Base loader not executable: $BASE_LOADER"

base_prompt="$("$BASE_LOADER" | awk '
	/^Apply the project initialization standard for this session\./ {
		capture = 1
	}
	/^# -+$/ && capture {
		exit
	}
	capture {
		print
	}
')" || fail "Could not load base initialization prompt"

[ -n "$base_prompt" ] || fail "Base initialization prompt was empty"

aider_rules='

Aider operating rules for this session:

During initialization, standards loading, planning, review, repository inspection, audit, or any request that says “do not edit”:
- Do not modify files.
- Do not apply patches.
- Do not commit.
- Do not run automatic lint-fix attempts.
- Do not treat suggestions, cleanup options, or review findings as permission to edit.
- Summarize findings and wait for explicit implementation approval.

For implementation tasks:
- Before editing, state the intended files and changes.
- Edit only after I explicitly approve implementation.
- Auto-commit is allowed only for approved implementation work.
- Commit messages should be concise and specific.
- If you are uncertain whether approval was given, ask before editing or committing.
'

prompt="$base_prompt$aider_rules"

print_banner "actual Aider prompt shown below"
printf '\n'
printf '%s\n' "$prompt"
printf '\n'

if command -v pbcopy >/dev/null 2>&1; then
	printf '%s\n' "$prompt" | pbcopy
	print_banner "Copied the above Aider initialization prompt to clipboard."
else
	print_banner "pbcopy not found; prompt was printed but not copied."
fi
