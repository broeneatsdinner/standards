# Script Headers

This document defines top-of-file standards for executable scripts and sourced
script files.

Script headers should make files immediately recognizable, visually consistent,
easy to scan, and safe for both humans and AI tools to regenerate.

## Related standards

For standards covering comments and documentation inside the body of scripts,
including function comments and commented directory trees, see
`docs/script-content.md`.

For general cross-language code-style rules, including indentation, minimal
diffs, reusable examples, and environment-neutral commands, see
`docs/code-style.md`.

## Shebangs

Executable scripts should use `/usr/bin/env` shebangs so the interpreter is
resolved from the user's environment instead of being hard-coded to a fixed
path.

Common defaults:

```bash
#!/usr/bin/env bash
```

```zsh
#!/usr/bin/env zsh
```

```python
#!/usr/bin/env python3
```

Rules:

- Use `#!/usr/bin/env bash` for executable Bash scripts.
- Use `#!/usr/bin/env zsh` for executable Zsh scripts.
- Use `#!/usr/bin/env python3` for executable Python scripts.
- For other executable script types, prefer `#!/usr/bin/env <interpreter>` when
  the interpreter is expected to come from the user's environment.
- Do not add a shebang to files that are intended only to be sourced, imported,
  loaded, or included by another file.
- Do not use hard-coded interpreter paths such as `/bin/bash`, `/bin/zsh`, or
  `/usr/bin/python3` unless a project has a specific operational reason to do
  so.

## Standard graphical header

Use a short graphical header near the top of important scripts.

The graphical header should appear after the shebang when a shebang is present.

Example:

```bash
#!/usr/bin/env bash
# ---------------------------------------
# --    rebuild_icns_from_wonder.sh    --
# ---------------------------------------
```

The header should be simple, readable, consistent, and precise.

The name in the header should identify the script or file role.

## Graphical header precision

Graphical headers must be precise.

The middle header line is the source of truth. The top and bottom border lines
must be generated from the measured character length of the middle line, not
estimated visually.

The middle line should use the script filename exactly as it appears on disk,
including the extension when one exists.

Pattern:

```bash
# --    filename.ext    --
```

For files without an extension, use the exact filename:

```bash
# --    aliases    --
```

The top and bottom lines must:

- start with `# `
- continue with `-`
- match the exact character length of the middle line

Good:

```bash
# ---------------------------------------
# --    rebuild_icns_from_wonder.sh    --
# ---------------------------------------
```

Also good:

```bash
# -------------------
# --    aliases    --
# -------------------
```

Do not hand-guess the number of dashes. Count the middle line first, then create
top and bottom border lines of the same length.

## Description metadata

After the graphical header, include a `# description:` metadata line when
helpful.

Example:

```bash
# description: Build 1024x1024 PNG masters and modern .icns files from upscaled Topaz Wonder PNG exports.
```

The `# description:` line is metadata. It may remain a single line because
external tools, launchers, indexes, menus, or other apps may consume it and
handle their own formatting.

Do not manually wrap `# description:` at 80 columns unless there is a specific
project reason to do so.

The description should be operational, not decorative.

It should summarize what the file does in one clear sentence.

## Description paragraph

After `# description:`, include a normal commented paragraph when the file needs
more explanation.

Use a blank commented line between `# description:` and the paragraph.

Example:

```bash
# description: Build 1024x1024 PNG masters and modern .icns files from upscaled Topaz Wonder PNG exports.
#
# This script is intended to be run from a remaster working directory that
# contains an upscaled-png subdirectory.
#
# It searches that directory for PNG files with "-wonder" somewhere in the
# filename, normalizes each one to a 1024x1024 PNG master, and then builds a
# modern .icns file from each normalized PNG.
```

Description paragraphs should answer relevant operational questions:

- what this file is
- whether it is run or sourced
- when to run it
- what inputs it expects
- what outputs it creates
- whether it has side effects
- whether it modifies, preserves, or deletes files

Normal paragraph comments should be wrapped around 80 columns.

For sourced shell components, adapt the paragraph to the file type. Do not say
the file is meant to be run directly. Explain how it is loaded or sourced, what
boundary it owns, and any platform assumptions or side effects that matter.

## Example: runnable Bash script

```bash
#!/usr/bin/env bash
# -----------------
# --    macos    --
# -----------------
# description: Apply macOS defaults and UI behavior tweaks.
#
# This file is meant to be run directly with Bash, not sourced:
#
#	bash ~/.dotfiles/macos
#
# Re-run it whenever you want to reapply these macOS settings.
# Some changes may require quitting/reopening affected apps, logging out,
# or restarting before they fully take effect.
```

## Example: sourced shell file

```bash
# ------------------
# --    colors    --
# ------------------
# description: Define shared terminal color values for shell scripts.
#
# This file is meant to be sourced by other shell scripts, not run directly.
#
# It owns color variables only. Terminal control, output formatting, and loader
# behavior belong in separate sourced components.
```

## Rules

- Use single-# comments.
- Use `/usr/bin/env` shebangs for executable scripts.
- Do not add shebangs to files that are only sourced, imported, loaded, or
  included.
- Keep the graphical header compact.
- Make graphical headers precise.
- Use the exact filename in the graphical header, including extension when one
  exists.
- Generate top and bottom graphical-header borders from the measured length of
  the middle line.
- Do not hand-guess graphical-header border length.
- Put `# description:` before longer explanatory paragraphs.
- Keep `# description:` as a single metadata line unless there is a specific
  project reason to wrap it.
- Put normal explanatory comments after `# description:` and a blank commented
  line.
- Put header documentation before implementation logic.
- Do not over-explain obvious files.
- Use tabs for indentation in code examples.
- Use spaces for visual alignment when needed.
