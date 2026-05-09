# Project Initialization Prompt

## Standard startup prompt

Use this prompt at the start of a new ChatGPT chat, local Codex session, or remote Codex session:

```text
Apply the project initialization standard for this session.

First, locate the standards repository.

If a standards repository is available at:

~/Documents/Git/standards

use it.

If that path is unavailable, use the public standards repository URL supplied for this session:

https://github.com/broeneatsdinner/standards

Read prompts/project-initialization.md first. Then read the referenced standards cascade. If standards may have changed recently, re-fetch the relevant files from the standards repository before applying them. After reading the applicable standards, summarize the active rules for the current task before making edits or giving implementation instructions.

Do not modify files until the applicable standards have been read or until you have clearly stated which referenced files were unavailable or not relevant.
```

This repository is the canonical standards authority for coding, documentation, shell, prompt, repository, and publication workflows.

## Operating instruction

Before generating or modifying code, documentation, prompts, examples, scripts, or repository structure, apply the standards in this repository.

Use this file as the entrypoint, then follow the standards cascade below.

## Standards repository location

First, look for the standards repository at:

```text
~/Documents/Git/standards
```

If that path does not exist or is not accessible, use the public standards repository URL supplied by the user or session.

When operating in a remote or temporary environment, clone or inspect the public repository before applying standards, unless the user explicitly says not to fetch it.

## Standards freshness

When using a local standards repository, use the current working copy as the source of truth by default.

Fetch or pull only when the user explicitly asks for latest remote verification, the local repository appears stale or inconsistent, the local standards repository is unavailable, or the task specifically depends on remote freshness.

Do not perform network fetches merely because the latest local commit is recent.

Keep initialization fast and local-first while still allowing freshness checks when they actually matter.

When using a public web source, prefer the latest default-branch content. If the user indicates that the standards were recently updated, re-fetch the relevant files instead of relying on cached conversation context.

Do not assume previously loaded standards are current after the user says the repository has changed.

## Initialization procedure

When this prompt is applied in Codex or another repository-aware AI coding tool, do not treat it as a standalone summary.

First, locate the standards repository.

Prefer:

```text
~/Documents/Git/standards
```

If that path is unavailable, use the public standards repository URL supplied by the user or session.

Then read this file from the standards repository.

Then read each referenced standards document in the standards cascade when it exists.

Also inspect relevant files under `directory_structures/` when repository layout, project scaffolding, or multi-node architecture is part of the task.

After reading the applicable standards, summarize the active rules for the current task before making changes.

Do not begin editing until the applicable standards have been read, or until you have clearly stated which referenced files were missing or not relevant.

## Session state and re-entry

Treat this initialization prompt as a one-time session setup step.

If the standards have already been loaded in the current session, do not restate or reload the full standards cascade unless:

- the user explicitly asks for a reload
- the standards repository has changed and the user wants the updated rules applied
- the task enters a specialized workflow whose standards have not yet been loaded
- required referenced files were unavailable during the earlier initialization

After initialization has already been completed, follow-up prompts should assume the loaded standards remain active for the rest of the session.

In those follow-up prompts, refer to the loaded standards briefly rather than redefining them in full.

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

## Specialized prompt loading

The initialization prompt should be fast to run once at the start of a session.

Do not load every specialized prompt file by default.

Always load the standing standards cascade, including `prompts/universal.md`.

Treat the remaining files under `prompts/` as specialized workflow prompts. Inspect `prompts/README.md` or list `prompts/` to understand what specialized workflows are available, but only read the full specialized prompt files when the current task enters that workflow.

Examples:

- Load `publication-opsec-*` prompts when preparing, auditing, remediating, or publishing public repositories, public screenshots, logs, configs, media, or portfolio artifacts.
- Load `filename-*` prompts when auditing, normalizing, or remediating filenames.
- Load `script-header-audit.md` when auditing script headers.

When a specialized workflow has numbered phases, respect the phase boundaries.

Do not jump from initiation to audit, remediation, deletion, renaming, redaction, or publication unless the user explicitly approves that scope.

If a task may involve public exposure, OPSEC, sanitization, screenshots, logs, configs, infrastructure details, secrets, private identifiers, or publication readiness, pause and load the relevant publication OPSEC prompt before giving implementation instructions or making edits.

Principle:

Initialize once. Load standing standards immediately. Load specialized workflow prompts only when the task requires them.

## ChatGPT behavior

When this prompt is applied in ChatGPT, do not assume access to the local filesystem.

Use the standards already present in the conversation first.

If the standards repository is not present in the conversation, use uploaded standards files, current conversation context, or the public standards repository URL supplied by the user.

When using a public repository source, read `prompts/project-initialization.md` first, then read the referenced standards cascade.

Summarize the active standards before giving project-specific code or modification instructions.

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

Do not assume helper scripts should be installed into `~/bin`. Helper commands may live in a user-managed command directory such as `~/.dotfiles/bin`, often as symlinks to scripts in project repositories, `~/Shell`, or other maintained source locations.

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
