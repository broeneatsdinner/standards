# Selectors and Menus

This document defines standards for interactive terminal selectors and menus.

## Philosophy

Selectors should make terminal tools easier to operate without sacrificing clarity or safety.

They should provide fast keyboard-driven interaction while keeping choices explicit.

## Use cases

Selectors are useful for:

- choosing files
- choosing directories
- choosing actions
- confirming operational paths
- selecting from generated candidates
- choosing script modes
- presenting safe menus for destructive operations

## Standard controls

Preferred selector controls:

```text
Up / Down       move selection
Enter           confirm selection
q               quit
Esc             quit or cancel
Ctrl-C          abort
```

When appropriate:

```text
Space           toggle selection
/               search or filter
```

## Menu behavior

Menus should:

- show the current selection clearly
- avoid ambiguity
- provide a clear cancel path
- never perform destructive work without confirmation
- return useful status codes
- degrade cleanly when run in non-interactive contexts

## Safety

For destructive or modifying actions, prefer a two-step flow:

1. Select the action or target.
2. Confirm before modifying files or system state.

Dry-run should be the default when a tool moves, renames, deletes, overwrites, or reorganizes files.

## Display

Selector output should be compact and readable.

Use color and highlighting consistently.

Avoid excessive animation inside menus.

## Non-interactive fallback

Interactive tools should provide non-interactive flags when practical.

Examples:

```text
--force
--dry-run
--select
--all
--plain
```

A tool should not require arrow-key interaction if it is intended to be used in scripts or automation.

## Reusable selector library

Shared selector behavior should live in:

```text
shell/selector.sh
```

Project-specific scripts should source the shared selector library instead of reimplementing menu behavior repeatedly.

## Return values

Selectors should return values in a predictable way.

Preferred patterns:

- print the selected value to stdout
- return success when a selection is made
- return non-zero when cancelled or aborted

Example behavior:

```text
stdout: selected item
exit 0: selection made
exit 1: cancelled
exit 130: interrupted
```

## Rule of thumb

A selector should reduce operator friction without hiding what will happen next.
