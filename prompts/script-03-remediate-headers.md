# Script Header Remediation Prompt

Use this prompt only after a script standards audit has produced findings and a human has explicitly approved script header remediation.

The goal is to make approved, scoped fixes to script identity and top-of-file metadata.

Do not commit anything.

## Invocation instructions

Copy and paste this into Codex after audit findings have been reviewed and script header remediation has been explicitly approved:

```text
Please use prompts/script-03-remediate-headers.md as your operating prompt and apply it to this repository.

This is an approved script header remediation workflow.

Use the prior audit findings from prompts/script-02-audit.md as the remediation basis.

Approved scope:

- [describe the approved script header findings, files, or paths here]

Do not touch unrelated files.

Do not rewrite script bodies, function comments, indentation, or shell logic.

Do not commit anything.

After remediation, show me:

- files changed
- header findings addressed
- remaining issues
- verification performed
- git status
- confirmation that no commit was made
```

## Task

Apply approved script header remediation.

Use only the audit findings and the explicit human-approved scope.

Make the smallest practical changes that correct approved top-of-file script identity issues.

## Required basis

This prompt requires:

- prior audit findings
- explicit human approval
- clear remediation scope

If those are missing, stop and ask for them.

Do not infer broad remediation authority from the existence of this prompt.

## Allowed targets

Allowed targets, when explicitly in scope:

- executable script shebangs
- graphical script headers
- exact filename text in graphical headers
- graphical-header border length
- `# description:` metadata
- short top-of-file paragraph descriptions
- run-directly versus sourced-file descriptions near the header

## Out of scope

Do not change:

- script body logic
- function comments
- body comments
- indentation outside the approved header block
- trailing whitespace outside edited header lines
- output banners
- examples outside the approved header block
- unrelated files

Do not rename files unless explicitly approved.

Do not commit anything.

## Remediation rules

Use `/usr/bin/env` shebangs for executable scripts.

Do not add shebangs to files intended only to be sourced, imported, loaded, or included.

Use the exact filename in graphical headers.

Generate top and bottom graphical-header borders from the measured length of the middle line.

Use `# description:` metadata when helpful and keep it as a single metadata line unless the project has a specific reason to wrap it.

Add paragraph descriptions only when they answer useful operational questions.

Preserve existing formatting outside the approved header block.

## Verification

After remediation:

1. Review the changed files.
2. Verify exact filenames and header border lengths.
3. Check for accidental trailing whitespace on edited lines.
4. Run `git status`.

## Report format

Produce a report with these sections:

1. Files changed
2. Header findings addressed
3. Verification
4. Remaining issues
5. Git status

State clearly that no commit was made.
