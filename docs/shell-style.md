# Shell Style

This document defines shell-script style standards for my local tools, helper applications, dotfiles, and operator workflows.

For general cross-language code-style rules, including indentation, minimal diffs, reusable examples, and environment-neutral commands, see `docs/code-style.md`.

## Core style

- Prefer Bash for portable helper scripts unless there is a specific reason to use Zsh.
- Use clear variable names.
- Quote variables unless intentionally using word splitting.
- Prefer predictable control flow over clever compression.
- Prefer readable commands over dense one-liners in scripts.
- Use functions to separate meaningful operations.
- Keep user-facing output clear, direct, and operational.

## Indentation

The canonical cross-language indentation standard lives in `docs/code-style.md`.

Use tabs for indentation.

Use spaces for alignment.

This means indentation levels are represented with actual tab characters, while visual alignment inside a line may use spaces.

Example:

```bash
if [[ -f "$config_file" ]]; then
	printf '%s\n' "Config found: $config_file"
else
	printf '%s\n' "Config missing: $config_file"
fi
```

For aligned text output:

```bash
printf '%-12s %s\n' "Status:" "ready"
printf '%-12s %s\n' "Config:" "$config_file"
```

## Comments

Use single-# comments for one-line descriptions.

Prefer comments above the thing they describe.

Do not use trailing inline comments unless they materially improve readability.

Preferred:

```bash
# Show only currently running applications in the Dock
defaults write com.apple.dock static-only -bool true
```

Avoid:

```bash
defaults write com.apple.dock static-only -bool true # Show only running apps
```

## Safety

Destructive operations should be obvious.

Old scripts and local helper scripts should be treated as untrusted until they
have been reviewed. Executable permission does not imply a script is safe to
run.

A script that performs destructive, irreversible, filesystem-mutating,
network-affecting, service-affecting, credential-affecting, or externally
visible actions must not perform those actions by default without an explicit
operator signal.

No-argument execution should be safe.

Acceptable no-argument behavior:

- show usage or help
- print status
- preview intended actions
- run in dry-run mode
- perform only clearly read-only or visual/demo behavior

No-argument execution must not delete, overwrite, rename, move, recursively
`chmod` or `chown`, truncate, sync-delete, restart services, alter firewall or
network state, write to remote systems, mutate APIs, or perform bulk filesystem
changes.

Harmless visual/demo scripts, read-only inspection scripts, and scripts that
only print output may safely run with no arguments, but they should still be
documented clearly.

Prefer dry-run behavior for tools that move, rename, delete, overwrite, or
reorganize files.

Use explicit operator signals for actions that modify files, systems, services,
networks, credentials, remotes, or external APIs.

Examples:

```text
--apply
--execute
--delete
--force
--yes
--no-dry-run
```

Do not use `--force` as the only protection for highly destructive actions when
a safer `--dry-run` / `--apply` model is appropriate.

Destructive scripts should include:

- clear usage text
- argument validation
- unknown-argument rejection
- dry-run support where practical
- printed target paths before destructive action
- quoted variables and `--` before path operands
- refusal to operate on empty, root, home, or suspiciously broad target paths
  unless explicitly designed and guarded
- comments explaining dangerous sections
- exit status 2 for usage errors
- exit status 1 for operational failure

Prefer this pattern:

```bash
dry_run=true
target_dir=""

usage() {
	printf '%s\n' "Usage: cleanup-cache [--dry-run] [--apply] TARGET"
}

fail() {
	printf 'ERROR: %s\n' "$*" >&2
	exit 1
}

usage_error() {
	printf 'ERROR: %s\n' "$*" >&2
	usage >&2
	exit 2
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		--dry-run)
			dry_run=true
			;;
		--apply)
			dry_run=false
			;;
		-*)
			usage_error "Unknown option: $1"
			;;
		*)
			[[ -z "$target_dir" ]] || usage_error "Too many targets."
			target_dir="$1"
			;;
	esac

	shift
done

if [[ -z "$target_dir" ]]; then
	usage
	exit 0
fi

[[ "$target_dir" != "/" ]] || usage_error "Refusing to operate on /."
[[ "$target_dir" != "$HOME" ]] || usage_error "Refusing to operate on HOME."
[[ -d "$target_dir" ]] || fail "Target directory not found: $target_dir"

cache_file="$target_dir/generated.cache"

printf '%s\n' "Target: $target_dir"
printf '%s\n' "Cache file: $cache_file"

# Remove generated cache files only after the operator has chosen apply mode.
if "$dry_run"; then
	printf '%s\n' "Dry run: would remove $cache_file."
else
	rm -f -- "$cache_file"
fi
```

Commands and patterns that require extra review or guardrails:

- `rm`, especially `rm -rf`
- `find -delete`
- `mv` or `cp` overwrite workflows
- `chmod -R` or `chown -R`
- `truncate`
- `dd`
- `diskutil` or `mkfs`-style operations
- `rsync --delete`
- `scp` or `rsync` remote writes
- `curl` or API `POST`, `PUT`, `PATCH`, or `DELETE`
- `git clean` or `git reset --hard`
- service restarts or stops
- firewall or network configuration changes
- package install or remove operations

## Output

Use `printf` instead of `echo` for predictable output.

Preferred:

```bash
printf '%s\n' "Done."
```

Avoid:

```bash
echo "Done."
```

## Arrays

Quote array expansions unless intentionally splitting.

Preferred:

```bash
printf '%s\n' "${items[@]}"
```

Avoid:

```bash
printf '%s\n' ${items[@]}
```

## Paths

Always quote paths.

Preferred:

```bash
cp "$source_file" "$destination_file"
```

Avoid:

```bash
cp $source_file $destination_file
```

## Entrypoints and libraries

User-facing commands belong in `bin/`.

Reusable sourced code belongs in `shell/`.

Internal project helpers belong in `scripts/`.

A shell script should make it clear whether it is intended to be run directly or sourced.

For the planned public shell library architecture, component boundaries, and source-library policy, see `docs/shell-components.md`.
