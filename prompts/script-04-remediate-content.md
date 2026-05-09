# Script Content Remediation Prompt

Use this prompt only after a script standards audit has produced findings and a human has explicitly approved script content remediation.

The goal is to make approved, scoped fixes to script bodies, comments, indentation, whitespace, examples, and shell style.

Do not commit anything.

## Invocation instructions

Copy and paste this into Codex after audit findings have been reviewed and script content remediation has been explicitly approved:

```text
Please use prompts/script-04-remediate-content.md as your operating prompt and apply it to this repository.

This is an approved script content remediation workflow.

Use the prior audit findings from prompts/script-02-audit.md as the remediation basis.

Approved scope:

- [describe the approved script content findings, files, or paths here]

Do not touch unrelated files.

Do not alter graphical script headers unless I explicitly approve that scope.

Do not commit anything.

After remediation, show me:

- files changed
- content findings addressed
- remaining issues
- verification performed
- git status
- confirmation that no commit was made
```

## Task

Apply approved script content remediation.

Use only the audit findings and the explicit human-approved scope.

Make the smallest practical changes that correct approved script-body issues while preserving behavior.

## Required basis

This prompt requires:

- prior audit findings
- explicit human approval
- clear remediation scope

If those are missing, stop and ask for them.

Do not infer broad remediation authority from the existence of this prompt.

## Allowed targets

Allowed targets, when explicitly in scope:

- function comments
- explanatory body comments
- indentation and alignment
- accidental trailing whitespace
- shell quoting
- `printf` output style
- readable control flow
- neutral reusable examples
- pager-safe commands in reusable examples
- other approved script body/content findings

## Out of scope

Do not change:

- graphical script headers
- exact filename text in headers
- header border lengths
- shebangs
- `# description:` metadata
- top-of-file paragraph descriptions
- unrelated files

Do not rename files unless explicitly approved.

Do not commit anything.

## Remediation rules

Preserve behavior.

Prefer minimal, targeted diffs.

Preserve existing formatting unless a standards fix requires changing it.

Use tabs for indentation and spaces for alignment unless the file format requires otherwise.

Use single-`#` comments for ordinary explanations.

Comment functions when the comment adds operational value.

Wrap script-body prose comments around 80 columns, but do not damage literals such as commands, paths, URLs, regexes, or option names.

Quote variables and paths unless intentionally using word splitting.

Use `printf` instead of `echo` for predictable shell output when changing affected lines.

Avoid pagers in reusable commands when practical.

Use neutral reusable examples.

## Verification

After remediation:

1. Review the changed files.
2. Search for accidental trailing whitespace in changed files.
3. Run repository-appropriate lightweight checks when available and relevant.
4. Run `git status`.

## Report format

Produce a report with these sections:

1. Files changed
2. Content findings addressed
3. Verification
4. Remaining issues
5. Git status

State clearly that no commit was made.
