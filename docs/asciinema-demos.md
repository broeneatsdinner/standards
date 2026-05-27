# Asciinema Demos

This document defines the standard for terminal recordings used in public repositories and portfolio-facing documentation.

## Purpose

Asciinema demos should be:

- readable in embedded README layouts
- operationally clear
- visually calm
- reproducible
- free of unnecessary personal or infrastructure identifiers

These demos are meant to show real tool usage, not terminal aesthetics for their own sake.

## Default recording size

Use this terminal size unless a project has a specific reason to do otherwise:

```sh
stty cols 90 rows 28
```

Rationale:

- 90 columns gives menu-driven tools enough horizontal room
- 28 rows gives enough vertical room for selectors, prompts, and short command output
- the result still embeds well in a README without feeling oversized

## Default demo prompt

For public demos, use a plain, uncolored, OPSEC-safe prompt with no username or hostname.

Preferred temporary prompt:

```sh
export PS1='${PWD#$HOME/Documents/Git/} > '
```

Examples:

- `fileorg >`
- `fileorg/demo >`
- `fileorg/demo/sorted >`

This is a temporary demo prompt for recording sessions, not a recommendation for normal day-to-day shell prompt configuration.

This prompt keeps the visible path useful while avoiding:

- username exposure
- hostname exposure
- full absolute home-directory paths
- unnecessary shell styling noise

## Prompt requirements

For public terminal demos, the prompt should:

- show only project-relative path context when practical
- avoid color unless color is part of the tool behavior being demonstrated
- avoid username and hostname
- avoid timestamps
- avoid unrelated git decorations unless branch state is part of the demo
- avoid decorative prompt symbols that reduce readability

## Terminal preparation

Before recording:

- move into a clean demo directory
- use sanitized example files and directory names
- set the terminal size
- set the demo prompt
- clear the visible terminal state and scrollback buffer if practical

Typical setup:

```sh
stty cols 90 rows 28
export PS1='${PWD#$HOME/Documents/Git/} > '
clear
```

If your terminal supports a shortcut that clears both the visible screen and scrollback, that is preferred. Otherwise use the cleanest practical equivalent.

## Demo data

Prefer intentionally simple, sanitized demo files.

Good examples:

- `file1.jpg`
- `file2.jpeg`
- `demo/`
- `sorted/`

Avoid:

- personal names unless intentionally part of the portfolio story
- customer or client names
- real hostnames
- real account names
- cluttered real-world directories
- unrelated files that distract from the workflow

## Demo shape

Keep demos short and purposeful.

Recommended target:

- 30 to 60 seconds for README-top demos
- one primary workflow
- minimal dead time
- minimal recovery from mistakes unless error handling is the point of the demo

A good demo usually shows:

1. the initial state
2. the command or tool launch
3. the key interaction
4. the resulting output or changed state

## Command pacing

Type at a calm, readable pace.

Do not rush commands so quickly that the viewer cannot follow them.

When setup is repetitive and not central to the workflow, prefer doing setup before recording and record only the meaningful operator interaction.

## Output discipline

During the recording:

- avoid unrelated shell chatter
- avoid unnecessary environment inspection
- avoid pagers
- avoid excessive scrolling
- avoid long verbose logs unless the log itself is what is being demonstrated

The goal is to make the workflow legible on first viewing.

## Color guidance

Default prompt standard: no color.

Tool output may keep its normal color when that color is part of the real user experience and does not reduce readability.

If color is retained:

- keep it restrained
- ensure the demo remains readable without relying on color alone
- avoid color-heavy terminal themes that distract from the workflow

## README placement

For public repositories, place the asciinema near the top of the README after a short introduction.

Recommended README flow:

1. project title
2. short one-paragraph description
3. asciinema demo
4. installation or usage details
5. deeper workflow documentation

The demo should complement the written instructions, not replace them.

## Reusable checklist

Before recording a public demo:

- [ ] use a clean demo directory
- [ ] sanitize filenames and directory names
- [ ] set terminal size to `90 x 28`
- [ ] set the OPSEC-safe prompt
- [ ] clear the terminal state
- [ ] confirm the workflow fits comfortably in the chosen dimensions
- [ ] record only the meaningful interaction

## Reusable commands

Set terminal size:

```sh
stty cols 90 rows 28
```

Set demo prompt:

```sh
export PS1='${PWD#$HOME/Documents/Git/} > '
```

Example result:

If working in:

```text
~/Documents/Git/fileorg/demo
```

the prompt becomes:

```text
fileorg/demo >
```

If working in:

```text
~/Documents/Git/fileorg/demo/sorted
```

the prompt becomes:

```text
fileorg/demo/sorted >
```

## Notes

This standard is intentionally simple.

It exists to produce consistent, low-noise terminal recordings for public repositories and portfolio showcases.
