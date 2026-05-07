# Publication OPSEC Text Remediation Prompt

Use this prompt only after a publication OPSEC audit has produced findings and a human has explicitly approved text remediation.

The goal is to make approved, scoped documentation and text changes that reduce publication risk.

Do not commit anything.

## Invocation instructions

Copy and paste this into Codex after audit findings have been reviewed and text remediation has been explicitly approved:

```text
Please use prompts/publication-opsec-03-text-remediation.md as your operating prompt and apply it to this repository.

This is an approved text/documentation remediation workflow.

Use the prior audit findings from prompts/publication-opsec-02-audit.md as the remediation basis.

Approved scope:

- [describe the approved findings, files, or paths here]

Do not touch media assets, raw/private intake folders, git history, secrets, credentials, or unrelated files.

Do not commit anything.

After remediation, show me:

- files changed
- audit findings addressed
- remaining issues
- any approved items that could not be completed
- git status
```

## Task

Apply approved text and documentation remediation for publication OPSEC findings.

Use only the audit findings and the explicit human-approved scope.

Make the smallest practical changes that reduce publication risk while preserving the repository's public purpose.

## Required basis

This prompt requires:

- prior audit findings
- explicit human approval
- clear remediation scope

If those are missing, stop and ask for them.

Do not infer broad remediation authority from the existence of this prompt.

## Scope

Allowed targets, when explicitly in scope:

- text files
- Markdown documentation
- README files
- links
- references
- filenames, only when explicitly approved and safe

Allowed remediation actions:

- generalize unnecessary private details
- remove unnecessary private details
- replace precise personal, location, timing, or pattern-of-life detail with public-safe language
- update references that point to private, internal, or unsafe locations
- fix wording that creates publication risk
- update filenames only when the rename is explicitly approved, safe, and coordinated with references

Preserve meaning where possible.

Prefer generalization over deletion when the public reader still needs the concept.

## Out of scope

Do not touch:

- media assets
- screenshots
- images
- videos
- PDFs or other binary assets unless explicitly treated as text by tooling and approved
- `assets/private-inbox/`
- `assets/contact-sheets/`
- raw/private intake folders
- ignored private assets
- git history
- secrets
- credentials
- private keys
- tokens
- unrelated files

Do not rotate secrets.

Do not rewrite history.

Do not delete files unless explicitly approved.

Do not publish anything.

Do not commit anything.

## Remediation rules

Before editing, identify the specific findings being addressed.

Keep edits scoped to approved files and approved risks.

Do not sanitize by adding vague warnings in place of fixing the risky content.

Do not include secret values verbatim in notes, reports, commit messages, or replacement text.

If a finding requires media cleanup, history rewriting, secret rotation, or external account action, report it as remaining work instead of attempting it.

If a requested filename change could break links or references, update approved references or report the risk before proceeding.

## Verification

After editing, review the changed files.

Check for obvious broken references caused by the changes.

Run repository-appropriate lightweight checks when available and relevant.

Always run `git status` after remediation.

## Report format

Produce a report with these sections:

1. Files changed
2. Findings addressed
3. Remaining issues
4. Items not completed
5. Verification
6. Git status

State clearly that no commit was made.
