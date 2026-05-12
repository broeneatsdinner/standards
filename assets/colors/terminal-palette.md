# Terminal Palette

This document defines a restrained terminal color language for shell-output design.

The companion visual tear sheet is available in:

- `ansi-scene-terminal-palette.html`
- `ansi-scene-terminal-palette.css`

## Design principle

Default text is the baseline. Color is punctuation.

Use color to emphasize meaningful data, not to decorate output.

## Palette

| Display name | Shell token | HEX | CSS variable | Intended use |
| --- | --- | --- | --- | --- |
| Terminal Black | `TERMINAL_BLACK` | `#000000` | `--terminal-black` | Base field / void; background reference only. |
| Charcoal Field | `CHARCOAL_FIELD` | `#182a39` | `--charcoal-field` | Terminal background family; quiet working field. |
| Panel Gray | `PANEL_GRAY` | `#555555` | `--panel-gray` | Quiet panel field and subdued UI structure. |
| Steel Gray | `STEEL_GRAY` | `#8f8f8f` | `--steel-gray` | Secondary structure, borders, inactive metadata. |
| Bone White | `BONE_WHITE` | `#f5f5f5` | `--bone-white` | High-contrast foreground / hard text. |
| Acid Blue | `ACID_BLUE` | `#00aaab` | `--acid-blue` | Paths, structured references, navigation/signal. |
| Cyan Bloom | `CYAN_BLOOM` | `#55ffff` | `--cyan-bloom` | Bright cyan highlight; use sparingly for shine/emphasis. |
| Deep Signal Blue | `DEEP_SIGNAL_BLUE` | `#5555ff` | `--deep-signal-blue` | Cool secondary accent; rare, not routine status. |
| Acid Green | `ACID_GREEN` | `#55fd57` | `--acid-green` | Counts, percentages, successful measured values. |
| Matrix Green | `MATRIX_GREEN` | `#00aa00` | `--matrix-green` | Deeper green shade; optional gradient/shadow companion. |
| Alert Red | `ALERT_RED` | `#aa0000` | `--alert-red` | Actual errors or destructive/failure states only. |
| Warning Amber | `WARNING_AMBER` | `#ffaa00` | `--warning-amber` | Warnings/caution; semantic warning companion. |
| ANSI Yellow | `ANSI_YELLOW` | `#ffff55` | `--ansi-yellow` | Rare high-energy attention color; avoid routine use. |
| Hot Magenta | `HOT_MAGENTA` | `#ff55ff` | `--hot-magenta` | Rare decorative/accent color; not recommended for standard CLI semantics. |

## Shell-output grammar

### Data-value emphasis

Use `ACID_GREEN` for meaningful numeric/result values.

```text
emptytrash: deleted 3 top-level item(s), freeing up 48 KB of space
emptytrash: deleting 2 item(s): ~/.Trash
```

Color intent:

- `3`, `48 KB`, and `2` use `ACID_GREEN`
- `~/.Trash` uses `ACID_BLUE`
- command prefix and prose remain default

### Subcomponent emphasis

Use `ACID_BLUE` for structural brackets and `ACID_GREEN` for the semantic subcomponent label.

```text
charge:  80%
Device Name [Case]:  41%
Device Name [Left]:  82%
Device Name [Right]: 83%
```

Color intent:

- `[` and `]` use `ACID_BLUE`
- `Case`, `Left`, and `Right` use `ACID_GREEN`
- percentages remain default when matching current calm status-output behavior

### Warning and error semantics

```text
warning: recoverable condition needing attention
error: actual failure state
```

Color intent:

- `warning:` uses `WARNING_AMBER`
- `error:` uses `ALERT_RED`
- explanatory prose remains default

## Operational guidance

Color should support scanning.

Prefer:

- quiet labels
- default prose
- colored values
- semantic warning/error tokens only when needed

Avoid:

- coloring entire lines
- coloring routine prose
- using alert colors for decorative emphasis
- leaking local usernames, hostnames, absolute home paths, IP addresses, or other environment-specific details in public examples
