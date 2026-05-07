# Bash Visual Assets

This document defines standards for graphical and visual terminal assets used in shell scripts and helper applications.

## Philosophy

Terminal visuals should improve orientation, feedback, and identity.

They should make tools feel intentional without making them noisy.

Visual effects should serve an operational purpose:

- confirm that something is running
- show progress or waiting state
- create recognizable project identity
- separate sections of output
- make interactive choices easier to parse

## Types of visual assets

Common visual assets include:

- graphical script headers
- loaders and spinners
- progress indicators
- string-writing text effects
- ANSI art
- ASCII banners
- separators
- menus and selectors
- colorized status output

## Visual restraint

Visual polish is useful when it improves clarity.

Avoid effects that:

- slow down the tool
- make output harder to copy
- interfere with logs
- obscure error messages
- produce excessive terminal noise

## Loader standards

Loaders should be used when a command takes long enough that the user might wonder whether the script is still running.

A loader should:

- clearly indicate waiting or progress
- stop cleanly
- restore the cursor when finished
- avoid leaving stray characters on the terminal
- not hide errors

## Text effects

String-writing effects can be used for intros, banners, demos, and identity-driven tools.

They should not be used for high-volume operational output.

Good use cases:

- project intro screens
- terminal art
- controlled demos
- lightweight interactive tools

Poor use cases:

- logs
- machine-readable output
- error messages
- output meant to be copied directly into another command

## ANSI and ASCII assets

ANSI and ASCII assets should live under:

```text
assets/
```

Recommended structure:

```text
assets/
├── ansi/
├── ascii/
└── screenshots/
```

Use `assets/ansi/` for ANSI art files.

Use `assets/ascii/` for plain-text terminal banners.

Use `assets/screenshots/` for rendered references and documentation images.

## Output modes

Tools with visual effects should consider separate output modes:

```text
normal       human-readable output
quiet        reduced output
plain        no color or animation
debug        verbose diagnostic output
```

When practical, provide flags such as:

```text
--plain
--no-color
--quiet
--debug
```

## Copy-safe output

Visual output should not make copying important command output harder.

If a command produces paths, commands, tokens, or structured output, keep that output clean.

Decorative output should be separated from copy-critical output.

## Rule of thumb

Visuals should help the operator understand what is happening.

If the visual effect competes with the task, remove it.
