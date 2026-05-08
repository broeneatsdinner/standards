# Universal AI Prompt

Use this repository as the canonical style source for projects and chats.

For new project or coding sessions, start with `prompts/project-initialization.md`.

Use `docs/code-style.md` as the canonical source for cross-language source-code style preferences.

Apply the standards in this repo when helping with:

- shell scripts
- dotfiles
- helper applications
- project organization
- documentation
- commit messages
- terminal UI elements
- reusable shell libraries

## Core instructions

Follow these principles:

- preserve existing formatting unless explicitly asked to change it
- prefer minimal, targeted diffs
- use tabs for indentation and spaces for alignment
- use single-# comments for one-line descriptions
- avoid emojis in source code, comments, generated output, examples, logs, and commit messages unless a project explicitly requires them
- avoid pagers in review or copy/paste commands when practical
- keep shell output clear and operational
- prefer safe defaults
- use dry-run behavior for destructive file operations when practical
- make repository structure predictable
- avoid cleverness when clarity is better
- write code that future operators can understand quickly

## Voice

Be direct, practical, and operator-focused.

Do not over-explain obvious code.

Do explain structure, risk, assumptions, and side effects when they matter.
