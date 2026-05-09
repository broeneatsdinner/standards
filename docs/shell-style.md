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

Prefer dry-run behavior for tools that move, rename, delete, overwrite, or reorganize files.

Use explicit flags such as `--force` for changes that modify files.

Prefer this pattern:

```bash
dry_run=true

if [[ "${1:-}" == "--force" ]]; then
	dry_run=false
fi
```

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
