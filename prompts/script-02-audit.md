# Script Standards Audit Prompt

Use this prompt when auditing scripts for compliance with the repository script standards.

The goal is to identify script header, content, shell-style, and cross-language code-style issues.

Produce a report only.

This prompt does not grant mutation authority.

Do not edit, rename, move, delete, rewrite, publish, commit, or otherwise modify anything.

## Invocation instructions

Copy and paste this into Codex to run the script standards audit against the current repository:

```text
Please use prompts/script-02-audit.md as your operating prompt and apply it to this repository.

This is the audit phase for a script standards workflow.

Audit maintained scripts for compliance with the repository script standards.

Use docs/script-headers.md, docs/script-content.md, docs/shell-style.md, and docs/code-style.md as workflow context.

This is a report-only audit.

Do not edit, rename, move, delete, rewrite, publish, or commit anything.

After the audit, show me:

- script files audited
- files excluded or skipped
- findings by file
- header, shebang, filename, border, and description metadata findings
- paragraph description and sourced-library behavior findings
- function comment, indentation, trailing whitespace, shell-style, and content findings
- recommended follow-up remediation workflow
- git status
- confirmation that you did not mutate the repository
```

## Task

Audit maintained scripts in the current repository.

Report findings and candidate remediations.

Do not mutate the repository during the audit.

## Required references

Use these files as operating context:

- `docs/script-headers.md`
- `docs/script-content.md`
- `docs/shell-style.md`
- `docs/code-style.md`
- `prompts/script-03-remediate-headers.md`
- `prompts/script-04-remediate-content.md`

Use remediation prompts only as possible approved follow-up workflows.

## Standards to check

Check for:

- `/usr/bin/env` shebangs on executable scripts
- script graphical headers
- exact filename in graphical headers
- precise graphical-header borders
- `# description:` metadata
- paragraph descriptions when useful
- run-directly versus sourced-library behavior descriptions
- function comments where they add operational value
- tabs for indentation and spaces for alignment
- accidental trailing whitespace
- shell style consistency, including quoted variables and paths
- predictable `printf` output
- readable control flow
- clear comments that explain intent rather than syntax
- pager-safe commands in reusable examples
- neutral reusable examples

Identify files that are generated, vendored, third-party, archived, too small, or otherwise inappropriate for remediation.

## Safety constraints

Do not edit files during the audit.

Do not add script headers.

Do not rewrite comments.

Do not normalize indentation.

Do not delete trailing whitespace.

Do not rename, move, delete, publish, or commit anything.

When uncertain, report the uncertainty instead of implying remediation authority.

## Report

When finished, report:

- script files audited
- files intentionally skipped
- findings by file
- header remediation candidates
- content remediation candidates
- unsafe or uncertain remediation candidates
- recommended follow-up workflow
- git status
- confirmation that no files were edited, renamed, moved, deleted, committed, or otherwise changed

Wait for explicit remediation approval before making changes.
