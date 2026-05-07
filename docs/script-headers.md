# Script Headers

This document defines graphical script-header standards.

Script headers should make files immediately recognizable, visually consistent, and easy to scan.

## Standard graphical header

Use a short graphical header near the top of important scripts:

```bash
#!/usr/bin/env bash
# -----------------
# --    name     --
# -----------------
```

The header should be simple, readable, and consistent.

The name should be short and should identify the script or file role.

## Description block

After the graphical header, include a short description when helpful:

```bash
# Brief description of what this file does.
#
# This file is meant to be run directly with Bash, not sourced:
#
#	bash path/to/script
```

Descriptions should be operational, not decorative.

They should answer:

- what this file is
- whether it is run or sourced
- when to run it
- whether it has side effects

## Example: runnable script

```bash
#!/usr/bin/env bash
# -----------------
# --    macos    --
# -----------------

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

## Example: sourced library

```bash
#!/usr/bin/env bash
# ------------------
# --    colors    --
# ------------------

# Shared terminal color definitions.
#
# This file is meant to be sourced by other shell scripts, not run directly.
```

## Rules

- Use single-# comments.
- Keep the graphical header compact.
- Do not over-explain obvious files.
- Put the description before implementation logic.
- Use tabs for indentation in code examples.
- Use spaces for visual alignment when needed.

## Header width

Prefer compact headers.

The middle line should visually center the name, but exact spacing does not need to be mathematically perfect.

Good:

```bash
# ---------------------
# --    functions    --
# ---------------------
```

Also good:

```bash
# -------------------------
# --    ssh-hardening    --
# -------------------------
```

The goal is recognition and consistency, not decorative complexity.
