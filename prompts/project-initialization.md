# Project Initialization Prompt

Use this prompt when starting a new project, repository, Codex session, or ChatGPT coding thread.

This repository is the canonical standards authority for coding, documentation, shell, prompt, repository, and publication workflows.

## Operating instruction

Before generating or modifying code, documentation, prompts, examples, scripts, or repository structure, apply the standards in this repository.

Use this file as the entrypoint, then follow the standards cascade below.

## Standards cascade

Apply these standards in order when relevant:

1. Cross-language code style: `docs/code-style.md`
2. Shell style: `docs/shell-style.md`
3. Script headers: `docs/script-headers.md`
4. Script body comments and examples: `docs/script-content.md`
5. Comments and descriptions: `docs/comments-and-descriptions.md`
6. Commit behavior: `docs/commit-standards.md`
7. Repository organization: `docs/repo-organization.md`
8. Repository taxonomy: `docs/repo-taxonomy.md`
9. Directory structures: `directory_structures/`
10. AI-facing universal guidance: `prompts/universal.md`
11. Publication, audit, and OPSEC guidance when preparing public repositories or public artifacts

When standards overlap, prefer the most specific applicable document. For general source-code style, use `docs/code-style.md` as the canonical authority.

## Default behavior

Make minimal, targeted edits.

Preserve existing formatting unless the requested task explicitly includes formatting cleanup.

Avoid unrelated whitespace cleanup, quote normalization, comment rewriting, or stylistic churn.

Use tabs for indentation and spaces for alignment unless a language or file format has a specific reason to do otherwise.

Do not use emojis in source code, code comments, terminal output examples, log messages, generated script output, or commit messages unless a project explicitly requires them.

Use `/usr/bin/env` shebangs for executable scripts.

Use precise graphical script headers when creating scripts.

Use `# description:` metadata where appropriate.

Keep `# description:` as a single metadata line unless a project has a specific reason to wrap it.

Wrap script-body prose comments around 80 columns.

Do not manually wrap README.md prose or normal Markdown documentation paragraphs to 80 columns. Let the renderer, editor, or viewer wrap Markdown prose.

Use single-# comments for ordinary one-line descriptions above settings, commands, and configuration blocks.

Comment functions when the comment adds operational value.

Use neutral reusable examples. Do not include personal shell prompts, usernames, hostnames, machine names, home paths, private project paths, or environment-specific identifiers unless the exact environment is the subject being documented.

Avoid pagers in commands shown for review, copy, or paste when practical. Prefer `git --no-pager`, `GIT_PAGER=cat`, `PAGER=cat`, or equivalent approaches.

Do not assume helper scripts should be installed into `~/bin`. In the user's environment, helper commands normally live in `~/.dotfiles/bin`, often as symlinks to scripts in project repositories, `~/Shell`, or other maintained source locations.

Only suggest `PATH` changes when the task explicitly calls for installation or environment setup.

Use canonical short file extensions when equivalent forms exist, such as `.jpg` instead of `.jpeg` and `.html` instead of `.htm`.

Do not leave accidental trailing whitespace. Preserve intentional trailing whitespace only when a file format uses it semantically, such as Markdown hard line breaks.

## Markdown and copy/paste safety

When generating copy/paste Markdown that contains nested code fences, use longer outer fences such as four backticks so the rendered answer does not break.

Do not replace intentional Markdown hard-break spacing with HTML `<br>` tags unless a project explicitly uses that style.

## Git and review behavior

Prefer small, scoped commits after each meaningful change.

Commit messages should have a tight, concise one-line summary.

When useful, include a concise explanatory commit body after the one-line summary.

The commit body should explain what changed and why without becoming verbose.

Commit descriptions should support review, rollback, and future archaeology.

Avoid vague commit messages such as `update files`, `updates`, `misc changes`, or `fix stuff`.

Before committing, summarize:

- files changed
- what changed by file
- validation or grep commands used
- anything intentionally not changed
- suggested commit message

Do not commit unless the user asks for a commit, or unless the task explicitly says to commit after the scoped change.

## Output behavior

Give direct, terminal-ready commands.

Use pager-safe commands in examples.

Prefer exact commands over vague instructions.

When reviewing changes, use commands such as:

- `git --no-pager diff`
- `git --no-pager diff --cached`
- `git --no-pager show --stat HEAD`
- `git --no-pager log --oneline -5`

## Public repository and OPSEC behavior

When preparing public repositories, public examples, public screenshots, public logs, or portfolio artifacts, apply the repository's publication and OPSEC standards.

Do not publish secrets, keys, tokens, PSKs, private logs, databases, private infrastructure details, precise geolocation, private identifiers, or unsanitized configuration.

Use sanitized examples and placeholders when needed.

Keep discovery, assessment, approval, and remediation as separate phases when auditing public-release readiness.
