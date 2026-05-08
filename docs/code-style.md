# Code Style

This document defines cross-language source-code style standards for my repositories.

It is the canonical home for code-style preferences that are not specific to shell headers, script-body comments, or another narrower standard.

## Diff discipline

Prefer minimal, targeted diffs.

Preserve existing formatting when editing existing files.

Avoid unrelated whitespace cleanup, quote normalization, comment rewriting, or stylistic churn unless explicitly requested.

## Indentation and alignment

Use tabs for indentation and spaces for alignment unless a language or file format has a specific reason to do otherwise.

Indentation levels should use actual tab characters.

Visual alignment inside a line may use spaces.

## Emojis

Do not use emojis in source code, code comments, terminal output examples, log messages, generated script output, or commit messages unless a project explicitly requires them.

## File extensions

Use canonical short file extensions when equivalent forms exist.

Preferred:

```text
.jpg
.html
```

Avoid:

```text
.jpeg
.htm
```

## Reusable examples

Do not include personal shell prompts, usernames, hostnames, machine names, home paths, project paths, or environment-specific identifiers in reusable examples.

Prefer neutral prompts such as `$` in reusable examples unless the exact prompt is the subject being documented.

When generating copy/paste Markdown that contains nested code fences, use longer outer fences such as four backticks to avoid breaking Markdown rendering.

## Commands in examples

Avoid pagers in commands shown for review, copy, or paste when practical.

Prefer `--no-pager`, `GIT_PAGER=cat`, `PAGER=cat`, or equivalent approaches.

Do not assume helper scripts should be installed into `~/bin`.

In the user's environment, helper commands normally live in `~/.dotfiles/bin`, often as symlinks to scripts in project repositories, `~/Shell`, or other maintained source locations.

Only suggest `PATH` changes when the task explicitly calls for installation or environment setup.

## Comments

Use single-# comments for ordinary one-line descriptions above settings, commands, and configuration blocks.

Do not use double-## comments for ordinary setting descriptions.
