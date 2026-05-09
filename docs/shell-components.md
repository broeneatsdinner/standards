# Shell Components

This document records the planned public shell component architecture.

It is a decision record for future implementation work. It does not require the current `shell/` files to already match every decision.

## Architecture

Planned public shell components:

```text
shell/colors.sh
shell/terminal.sh
shell/loaders.sh
shell/output.sh
shell/text-effects.sh
shell/selector.sh
shell/headers.sh
```

### shell/colors.sh

`shell/colors.sh` owns the public color palette for shell output.

It should provide:

- canonical hex palette tokens
- generated shell truecolor ANSI output
- terminal-ready shell variables for scripts and prompts
- semantic color aliases
- `NO_COLOR` fallback
- non-TTY fallback

Hex color tokens are the canonical color source of truth. Shell ANSI and truecolor output should be generated from those tokens.

After sourcing `shell/colors.sh`, scripts and prompts should be able to use convenient terminal-ready variables such as `GREEN`, `RESET`, `SUCCESS`, `WARNING`, `ERROR`, `MUTED`, and `HEADING`. Those variables are part of the public shell API, but their escape sequences should be generated from canonical hex tokens rather than hand-maintained as a separate ANSI palette.

Do not maintain separate manual ANSI and `tput` color palettes. Use `tput` mainly for terminal control behavior, not the canonical color palette.

### shell/terminal.sh

`shell/terminal.sh` owns terminal control primitives.

It should provide:

- cursor hide/show helpers
- clear-line helpers
- terminal capability checks
- cleanup/trap primitives

Terminal cleanup should be reusable by loaders, selectors, and any shell UI that temporarily changes terminal state.

### shell/loaders.sh

`shell/loaders.sh` owns spinner and loader behavior.

It should provide:

- spinner frame sets
- start/stop lifecycle helpers
- cursor restoration
- clean completion output

Loader behavior should be safe to stop repeatedly and should restore terminal state on normal completion, cancellation, and interrupt when practical.

### shell/output.sh

`shell/output.sh` owns common operator-facing output helpers.

It should provide:

- status, success, warning, and error lines
- wrapped paragraph output
- muted metadata output
- key/value output
- reset-safe colored output

Output helpers should pair color with clear text and should not rely on color alone for critical state.

### shell/text-effects.sh

`shell/text-effects.sh` owns optional text animation.

It should provide:

- typewriter/string animation
- animated wrapped text
- easing animation

Easing animation is intentionally part of the desired shell UI voice, but it must be optional or safely disableable. Any dependency-heavy animation should degrade cleanly when required commands or terminal capabilities are unavailable.

### shell/selector.sh

`shell/selector.sh` owns interactive selector behavior.

It should provide:

- keyboard-driven selection
- predictable stdout and status behavior
- explicit cancel handling
- interrupt handling

Selectors should return the selected value on stdout, return success when a selection is made, return non-zero on cancel, and return interrupt status when interrupted.

### shell/headers.sh

`shell/headers.sh` owns graphical and script header helpers.

It should stay focused on generating or validating the visual header shapes defined by the script header standard.

## Deferred Components

Do not add `shell/formatting.sh` yet.

Full table helpers are deferred for now. Add `shell/formatting.sh` later only if layout primitives such as tables, boxes, rules, columns, or section dividers outgrow `shell/output.sh`.

## Source Library Policy

Source-only shell libraries should not have shebangs.

Source-only shell libraries should keep source guards so direct execution fails clearly.

Runnable executable scripts should have `/usr/bin/env` shebangs.

Public shell variables may need targeted ShellCheck `SC2034` suppressions when they are intended sourced-library API.

## Sourced Component Documentation

Sourced shell components are not executable scripts and should not claim to be
run directly.

They are still documented source files.

Use top-of-file documentation adapted to the component type:

- include a graphical header when appropriate
- put a `# description:` line immediately after the graphical header
- add a short introductory comment block explaining how the file is loaded or
  sourced
- state the component boundary when relevant, such as aliases-only,
  functions-only, colors-only, or loaders-only
- document platform guards before platform-specific commands or settings
- use clear, useful, single-# section comments consistent with
  `docs/comments-and-descriptions.md`

Platform-specific sourced components should guard platform-specific commands
before they run. The comment near the guard should explain the operating-system
or shell assumption when it is not obvious.

## Private Source Sample Boundary

Files under `private/source-samples/` may inform mechanics and design direction.

Do not copy private demo content, screenshots, transcripts, hostnames, usernames, private paths, IP addresses, lyrics, project-specific labels, or analysis prose into public shell libraries or docs.

Extract reusable mechanics only.

## Future Implementation Order

Recommended implementation order:

1. Add terminal control helpers.
2. Refactor shell color tokens.
3. Add shell output helpers.
4. Harden loader lifecycle.
5. Add or refine text effects with optional easing.
6. Replace selector behavior.
7. Revisit formatting and table helpers later.
