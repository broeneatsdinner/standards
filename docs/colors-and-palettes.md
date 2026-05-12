# Colors and Palettes

This document defines color and palette standards for terminal scripts, visual shell components, loaders, menus, and text effects.

## Philosophy

Terminal colors should be intentional.

They should support readability, state, hierarchy, and identity.

Color should not be random decoration.

## Terms

A color palette is the selected set of colors used by a project or visual system.

Design tokens are named values that represent reusable design decisions.

In shell scripts, named color variables function like design tokens.

Example:

```bash
ICE=""
GREEN=""
RED=""
DIM=""
RESET=""
```

Hex color tokens should be the canonical source of truth for shell colors.

Terminal-ready variables such as `GREEN`, `RESET`, `SUCCESS`, `WARNING`, `ERROR`, `MUTED`, and `HEADING` should remain convenient to use after sourcing the shared color library, but their escape sequences should be generated from canonical hex tokens rather than maintained as a separate manual ANSI palette.

The generated escape sequences belong in reusable library files such as:

```text
shell/colors.sh
```

`shell/colors.sh` should also provide HEX-to-ANSI foreground conversion helpers
so scripts can derive truecolor terminal escapes from canonical hex tokens.

## Naming

Use semantic names when the color represents meaning.

Examples:

```bash
COLOR_SUCCESS
COLOR_WARNING
COLOR_ERROR
COLOR_MUTED
COLOR_RESET
```

Use aesthetic names when the color is part of a visual identity.

Examples:

```bash
ICE
FROST
CYAN
NEORB_BLUE
DIM
```

Both are valid.

Semantic names describe purpose.

Aesthetic names describe palette identity.

## Pairings

Color pairings should be documented when they represent a recurring visual system.

Examples:

```text
ICE + DIM       calm technical output
GREEN + DIM     success with subdued context
RED + DIM       error with subdued context
CYAN + WHITE    bright operator emphasis
```

## Reset behavior

Every colored output sequence should return to reset.

Preferred:

```bash
printf '%b%s%b\n' "$GREEN" "Done." "$RESET"
```

Avoid leaving the terminal in a modified state.

## Accessibility

Do not rely on color alone for critical state.

Pair color with clear text.

Preferred:

```text
ERROR: Missing config file
```

Avoid:

```text
Missing config file
```

where color is the only error signal.

## Intensity

Use bright colors sparingly.

Use dim colors for context, metadata, separators, secondary labels, and less important details.

## Reusable color library

Shared colors should live in:

```text
shell/colors.sh
```

Project-specific scripts should source the shared library instead of redefining the same colors repeatedly.

Example:

```bash
# shellcheck source=../shell/colors.sh
source "$script_dir/../shell/colors.sh"
```

## Visual consistency

Use the same colors for the same meanings across projects.

Examples:

- success should look like success everywhere
- errors should look like errors everywhere
- muted metadata should look visually secondary everywhere
- menu selection should be visually consistent across selectors

## Rule of thumb

Color should make output easier to parse.

If color makes output harder to read, remove it.
