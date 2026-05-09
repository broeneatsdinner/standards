# Script Standards Initiation Prompt

Use this prompt when starting a script standards workflow for a repository.

The goal is to identify candidate script files, determine which script standards apply, and recommend the next workflow phase.

Do not modify files.

Do not commit anything.

## Invocation instructions

Copy and paste this into Codex to start the script standards workflow against the current repository:

```text
Please use prompts/script-01-initiate.md as your operating prompt and apply it to this repository.

This is the initiation phase for a script standards workflow.

Identify candidate script files and determine which script standards apply.

Use docs/script-headers.md, docs/script-content.md, docs/shell-style.md, and docs/code-style.md as workflow context.

Do not edit, rename, move, delete, rewrite, publish, or commit anything.

After initiation, show me:

- candidate script files and why they are in scope
- files that should be excluded or handled cautiously
- standards that apply to each script category
- whether prompts/script-02-audit.md should be run next
- whether remediation should be deferred until after audit findings and explicit human approval
- recommended next steps
- confirmation that you did not modify or commit anything
```

## Task

Start the script standards workflow for the current repository.

Identify maintained scripts and script-like files, classify whether they are executable scripts, sourced libraries, internal helpers, examples, templates, or generated/third-party files, and determine which script standards should apply.

Produce a workflow plan only.

## Required references

Use these files as operating context:

- `docs/script-headers.md`
- `docs/script-content.md`
- `docs/shell-style.md`
- `docs/code-style.md`
- `prompts/script-02-audit.md`
- `prompts/script-03-remediate-headers.md`
- `prompts/script-04-remediate-content.md`

Use `prompts/script-02-audit.md` as the next report-only audit phase.

Use remediation prompts only after audit findings exist and a human has explicitly approved a scoped change.

## Scope planning

Recommend an audit scope that may include:

- executable shell scripts
- sourced shell libraries
- helper scripts in `bin/`, `scripts/`, `tools/`, or similar directories
- script examples and templates maintained by the repository
- other script files with shebangs or shell syntax

Identify files that should normally be excluded or handled cautiously:

- generated files
- vendored or third-party files
- dependency folders
- caches
- archived files
- files that are too small to benefit from headers or expanded comments

When uncertain, report the uncertainty instead of expanding scope silently.

## Workflow direction

Recommend running `prompts/script-02-audit.md` when script compliance needs inspection.

Recommend `prompts/script-03-remediate-headers.md` only for approved header, shebang, filename, border, and `# description:` metadata fixes.

Recommend `prompts/script-04-remediate-content.md` only for approved script body, comment, indentation, trailing whitespace, and shell-style fixes.

## Safety constraints

Do not edit files.

Do not delete files.

Do not rename files.

Do not move files.

Do not rewrite script content.

Do not commit anything.

Do not run audit or remediation during initiation.

## Report format

Produce a report with these sections:

1. Candidate script files
2. Exclusions and uncertainties
3. Applicable standards
4. Recommended audit scope
5. Recommended workflow plan
6. Remediation boundary
7. Confirmation

State clearly whether `prompts/script-02-audit.md` should be run next.

Confirm that no files were modified and no commits were made.
