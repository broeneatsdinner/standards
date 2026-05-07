# System Default Prompt

The system default prompt preserves the operating system or distribution's default shell prompt.

## Purpose

Use `system_default` when the default prompt carries useful environmental meaning or when changing it would create unnecessary risk or confusion.

This is especially useful on systems where the default prompt is part of the expected operating environment.

## Rules

- do not override the default prompt
- do not modify distribution-specific prompt behavior
- do not replace meaningful environment cues
- allow the setup tooling to explicitly preserve this choice

## Example use case

Kali Linux should keep its default prompt unless explicitly changed.

The default prompt is part of the environment's identity and should not be casually replaced.
