# Filename Remediation Prompt

Use this prompt only after a filename audit has produced findings and a human has explicitly approved filename, directory-name, extension, or reference remediation.

The goal is to make approved, scoped normalization and remediation changes safely.

Do not commit anything.

## Invocation instructions

Copy and paste this into Codex after audit findings have been reviewed and filename remediation has been explicitly approved:

```text
Please use prompts/filename-03-remediate.md as your operating prompt and apply it to this repository.

This is an approved filename remediation workflow.

Use the prior audit findings from prompts/filename-02-audit.md as the remediation basis.

Approved scope:

- [describe the approved findings, files, paths, references, or normalization changes here]

Do not touch unrelated files.

Do not rename, normalize, move, rewrite, delete, edit, publish, or otherwise mutate anything outside the approved scope.

Do not commit anything.

After remediation, show me:

- files renamed, moved, edited, or otherwise changed
- audit findings addressed
- references updated
- verification performed
- remaining issues
- any approved items that could not be completed
- git status
- confirmation that no commit was made
```

## Task

Apply approved filename, directory-name, extension, and reference remediation.

Use only the audit findings and the explicit human-approved scope.

Make the smallest practical changes that correct the approved issue while preserving repository behavior, publication meaning, and downstream references.

## Required basis

This prompt requires:

- prior audit findings
- explicit human approval
- clear remediation scope

If those are missing, stop and ask for them.

Do not infer broad remediation authority from the existence of this prompt.

Do not treat an audit finding as approval to mutate repository state.

## Allowed targets

Allowed targets, when explicitly in scope:

- maintained source files
- documentation files
- prompt files
- public media assets
- asset folders
- examples and templates
- README files
- references that point to approved renamed or normalized paths
- indexes, manifests, build paths, or generated references when maintained by the repository

Allowed remediation actions, when explicitly approved:

- rename files
- rename directories
- normalize filename casing
- replace vague filenames with descriptive filenames
- replace vague directory names with operationally clear directory names
- normalize canonical extensions
- correct extension/content mismatches
- update references affected by approved renames or extension changes
- regenerate maintained indexes or previews when repository tooling clearly requires it

## Out of scope

Do not touch:

- unrelated files
- vendored files
- generated files unless they are explicitly approved and maintained by the repository
- dependency folders
- caches
- build output unless explicitly approved
- archived or third-party source copies unless explicitly approved
- ignored private intake folders unless explicitly approved
- raw media sources unless explicitly approved
- git history

Do not publish anything.

Do not commit anything.

Do not delete files unless explicitly approved.

Do not rewrite history.

Do not rotate secrets.

## Remediation rules

Before editing, identify the specific findings being addressed.

Keep changes scoped to approved files, paths, references, and downstream systems.

Prefer safe normalization that preserves meaning.

Use descriptive, public-safe names for public assets.

Use lowercase filenames and directories unless a conventional exception applies.

Keep `README.md` as the intentional conventional Markdown exception.

Use lowercase `.md` for other Markdown files.

Use `.jpg`, not `.jpeg`, when normalizing public JPEG assets.

Only change a media extension when the resulting extension truthfully matches the actual file type.

If file content and extension disagree, decide from the approved scope whether to rename the extension, convert the file content, or leave it as a remaining issue.

Do not silently normalize media filenames as part of unrelated remediation.

If an approved rename could affect external URLs, public paths, imports, builds, previews, or deployment behavior, update approved references and report any downstream risk that cannot be verified locally.

When a requested change is unsafe, ambiguous, or outside the approved scope, report it instead of guessing.

## Reference updates

For each approved rename, move, or extension change, update affected references that are also inside the approved scope.

Check for:

- Markdown links
- image references
- imports
- URLs
- build paths
- deployment paths
- manifests
- indexes
- static-site routes
- documentation paths
- generated previews
- external references called out by the repository

If a reference appears external or outside the approved scope, report it as remaining work unless the human approval explicitly includes it.

## Verification

After remediation:

1. Review the changed files.
2. Search for stale references to old paths.
3. Verify extension/content consistency for changed media when tooling is available.
4. Run repository-appropriate lightweight checks when available and relevant.
5. Verify rendering, builds, previews, indexes, or documentation links where applicable.
6. Run `git status`.

Do not install new tooling or access network resources unless separately approved.

## Report format

Produce a report with these sections:

1. Files changed
2. Mutations performed
3. Findings addressed
4. References updated
5. Verification
6. Remaining issues
7. Items not completed
8. Git status

State clearly that no commit was made.
