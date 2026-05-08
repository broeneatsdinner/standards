# Comments and Descriptions

This document defines comment and description standards for scripts, configuration files, documentation, and reusable components.

For general cross-language code-style rules, including minimal diffs, reusable examples, and indentation, see `docs/code-style.md`.

## Philosophy

Comments should explain intent.

They should help a future reader understand why something exists, what role it serves, and whether it has side effects.

Comments should not create noise.

## Single-line comments

Use single-# comments for one-line descriptions.

Do not use double-## comments for ordinary setting descriptions.

Preferred:

```bash
# Enable full keyboard navigation for buttons and controls in modal dialogs
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
```

Avoid:

```bash
## Enable full keyboard navigation for buttons and controls in modal dialogs
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
```

## Placement

Prefer comments above the thing they describe.

Preferred:

```bash
# Close System Settings so it does not overwrite defaults while this script runs
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true
```

Avoid trailing comments unless they are short and materially improve readability.

Avoid:

```bash
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true # Close System Settings
```

## Description blocks

A script description should appear after the graphical header and before implementation logic.

It should answer:

- what this file does
- whether it is run directly or sourced
- when to run it
- whether changes may require restarting, reopening, logging out, or other follow-up action

Example:

```bash
# macOS defaults and UI behavior tweaks.
#
# This file is meant to be run directly with Bash, not sourced:
#
#	bash ~/.dotfiles/macos
#
# Re-run it whenever you want to reapply these macOS settings.
# Some changes may require quitting/reopening affected apps, logging out,
# or restarting before they fully take effect.
```

## Section headers

Use larger visual section headers only when they improve navigation in longer files.

Example:

```bash
################################################################################
#
# Finder
#
################################################################################
```

Do not use large section headers for tiny files.

## Comments in shell libraries

Reusable libraries should describe what they provide and whether they should be sourced.

Example:

```bash
# Shared terminal color definitions.
#
# This file is meant to be sourced by other shell scripts, not run directly.
```

## Comments in configuration files

Configuration comments should be direct and operational.

Preferred:

```bash
# Keep SSH sessions alive through idle network periods
ServerAliveInterval 60
ServerAliveCountMax 3
```

## Avoid

Avoid comments that merely repeat the command.

Avoid:

```bash
# Make directory
mkdir -p "$target_dir"
```

Better:

```bash
# Ensure the target directory exists before writing output
mkdir -p "$target_dir"
```

## Rule of thumb

A good comment explains intent, risk, behavior, or context.

A bad comment narrates syntax.
