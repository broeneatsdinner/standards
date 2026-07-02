# Colors and Palettes

This document defines the shared shell color palette for terminal scripts, visual shell components, loaders, menus, prompts, and text effects.

## Philosophy

Terminal color should make output easier to parse. It should communicate state, hierarchy, and identity without becoming decoration.

The shared palette is explicit truecolor. Public colors are generated from documented RGB hex tokens, not from terminal-theme-dependent ANSI color slots. A script that uses `GREEN`, `CYAN`, `WHITE`, or `BLACK` is using a project-defined truecolor value, not whatever a terminal theme assigns to an ANSI slot.

Color should never be the only signal for critical state. Pair color with clear text such as `ERROR: Missing config file`.

## Public contract

The canonical shell color contract lives in:

```text
shell/colors.sh
```

The naming pattern is:

```text
TOKEN_HEX      canonical full-strength RGB color
TOKEN_DIM_HEX  dimmed RGB color
TOKEN          rendered ANSI foreground escape
TOKEN_DIM      rendered ANSI foreground escape for the dimmed color
```

`RESET` resets terminal formatting.

`BOLD` and `TEXT_DIM` are terminal text effects, not palette colors. `TEXT_DIM` is separate from calculated color dimming.

`shell/colors.sh` owns `NO_COLOR` and `FORCE_COLOR` behavior. When color is disabled, rendered variables such as `SUCCESS`, `SUCCESS_DIM`, `CYAN`, and `CYAN_DIM` are empty strings. Hex tokens remain available as data.

## Base Palette

Base colors define the project identity.

```bash
ACID_BLUE_HEX="#00aaab"
ACID_GREEN_HEX="#55fd57"
AMBER_HEX="#ffaa00"
ICE_HEX="#66ffff"
```

Each base token has a calculated dim token such as `ACID_BLUE_DIM_HEX` and rendered variables such as `ACID_BLUE` and `ACID_BLUE_DIM`.

## Semantic Palette

Semantic colors describe meaning. They alias base or classic colors instead of duplicating raw hex values.

```bash
SUCCESS_HEX="$ACID_GREEN_HEX"
WARNING_HEX="$AMBER_HEX"
ERROR_HEX="$RED_HEX"
GIT_BRANCH_HEX="$AMBER_HEX"
DIRTY_MARK_HEX="$RED_HEX"
```

`ERROR` and `DIRTY_MARK` intentionally use `RED_HEX`. That red is the standards red, `#ff5555`, not pure `#ff0000`.

## Classic Palette

Classic colors restore familiar public names while keeping the implementation explicit truecolor.

```bash
BLACK_HEX="#000000"
RED_HEX="#ff5555"
GREEN_HEX="#00ff00"
YELLOW_HEX="#ffff00"
BLUE_HEX="#0000ff"
MAGENTA_HEX="#ff00ff"
CYAN_HEX="#00ffff"
WHITE_HEX="#ffffff"
```

The rendered variables `BLACK`, `RED`, `GREEN`, `YELLOW`, `BLUE`, `MAGENTA`, `CYAN`, and `WHITE` are generated from these `*_HEX` tokens with truecolor foreground escapes. Do not reintroduce terminal ANSI slot escapes such as red slot 31 or cyan slot 36 as the public palette.

## Dimmed Colors

Most `*_DIM_HEX` values are generated with `dim_hex`, which blends the source color toward black. This gives scripts and previews a repeatable rule for dimmed color variants.

`BLACK_DIM_HEX="#181715"` is intentionally hand-tuned rather than calculated with `dim_hex`. A literal dimmed black would still be black, which is mathematically correct but not useful in a terminal window. The warm charcoal value keeps dimmed black visible while preserving the overall palette structure.

This is a small example of flexibility inside the standard: the rule handles the common case, and the documented exception handles the place where the visual result needs a human decision. Learn the rules so you can test them.

## Preview

Use `bin/showpalette` to inspect the palette.

It prints the sections in contract order:

1. BASE PALETTE
2. SEMANTIC PALETTE
3. CLASSIC PALETTE

For each token, the preview shows the full hex value, full sample, full swatch, dim hex value, dim sample, and dim swatch.

The sample phrase `lorem ipsum, [baby]` and swatch glyphs `▇▇▇▇` are intentional preview content. They provide a stable visual check for text color, punctuation, brackets, spacing, and swatch rendering.

## Usage

Source the shared library instead of redefining colors in scripts:

```bash
# shellcheck source=../shell/colors.sh
source "$script_dir/../shell/colors.sh"

printf '%b%s%b\n' "$SUCCESS" "Done." "$RESET"
printf '%b%s%b %s\n' "$TEXT_DIM" "branch:" "$RESET" "$GIT_BRANCH"
printf '%b%s%b\n' "$CYAN_DIM" "secondary detail" "$RESET"
```

Always reset colored output. Avoid leaving the terminal in a modified state.
