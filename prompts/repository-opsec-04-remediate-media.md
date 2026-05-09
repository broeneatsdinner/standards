# Repository OPSEC Media Remediation Prompt

Use this prompt only after a repository OPSEC audit has produced findings and a human has explicitly approved curated-media remediation.

The goal is to inspect and clean approved public media copies before publication.

Do not commit anything.

## Invocation instructions

Copy and paste this into Codex after audit findings have been reviewed and curated-media remediation has been explicitly approved:

```text
Please use prompts/repository-opsec-04-remediate-media.md as your operating prompt and apply it to this repository.

This is an approved curated-media remediation workflow.

Use docs/media-asset-workflow.md and the prior audit findings from prompts/repository-opsec-02-audit.md as the remediation basis.

Approved public media scope:

- [describe the approved public asset folders or files here]

Do not touch assets/private-inbox/, assets/contact-sheets/, raw intake originals, ignored private assets, git history, or unrelated files.

Preserve public filenames unless I explicitly approve a safe rename.

Do not commit anything.

After remediation, show me:

- files inspected
- metadata found before cleanup
- actions taken
- metadata status after cleanup
- files that could not be inspected or cleaned
- remaining issues
- git status
```

## Task

Apply approved curated-media remediation for repository OPSEC findings.

Use only the audit findings and the explicit human-approved public media scope.

Inspect and clean metadata where tooling is available.

## Required references

Use these files as operating context:

- `docs/media-asset-workflow.md`
- `prompts/repository-opsec-02-audit.md`

Follow the media workflow's distinction between raw intake, private quarantine, contact sheet review, curated public copies, metadata stripping, and final publication audit.

For large media sets, expect private numbered contact sheets and local number-to-filename indexes to exist as review artifacts.

Use those integer identifiers when they are provided in the approved scope or audit findings.

Do not publish contact sheets or indexes by default.

## Required basis

This prompt requires:

- prior audit findings
- explicit human approval
- clear public media remediation scope

If those are missing, stop and ask for them.

Do not infer broad media authority from the existence of this prompt.

## Scope

Allowed targets, when explicitly in scope:

- curated public media copies
- `assets/gear/`
- `assets/workflow/`
- `assets/reference/`
- `assets/finished-drinks/`
- other explicitly approved public asset folders

Private contact sheets and number-to-filename indexes may be read as review context when explicitly approved.

They are not publication targets by default.

Allowed remediation actions:

- inspect metadata
- strip metadata
- remove embedded thumbnails or previews where tooling supports it
- create cleaned public copies when needed and approved
- report extension/content mismatches as publication-quality defects
- preserve existing public filenames
- rename public files only when explicitly approved as safe

## Metadata to inspect

When tooling is available, inspect approved public media for:

- EXIF
- GPS/location data
- device make/model
- camera/app/software
- timestamps
- author/creator fields
- thumbnails/previews
- embedded coordinates

Treat missing tooling as a limitation.

Do not install new tools or access network resources unless separately approved.

## Out of scope

Do not touch:

- `assets/private-inbox/`
- `assets/contact-sheets/`
- contact sheet number indexes unless explicitly approved as read-only review context
- raw intake originals
- ignored private assets
- private quarantine folders
- unrelated files
- text remediation outside approved media references
- git history
- secrets
- credentials

Do not rewrite history.

Do not delete raw assets.

Do not publish anything.

Do not commit anything.

Do not rename files unless explicitly approved.

## Remediation rules

Before editing, identify the approved files or folders being inspected.

Record metadata found before cleanup without exposing sensitive values unnecessarily.

Strip metadata from approved public media copies where tooling supports it.

Preserve public filenames unless a safe rename is explicitly approved.

Do not treat metadata remediation as filename/type normalization.

If a file's extension does not match its actual type, report it as a separate publication-quality issue unless normalization has been explicitly approved for this run.

When numbered contact sheets or indexes are available, use stable integer identifiers in notes and reports alongside the public filename or source filename.

Do not copy private source filenames into public filenames unless explicitly approved and public-safe.

If metadata cannot be inspected or cleaned, report the file and the limitation.

If visible content creates a publication risk that metadata cleanup cannot solve, report it as remaining work.

If cleanup would require touching raw/private intake, git history, or ignored assets, stop and report the boundary.

## Verification

After cleanup, inspect metadata again where tooling is available.

Confirm whether the targeted metadata was removed.

Check `git status`.

Do not treat metadata cleanup as visible-content review completion.

## Report format

Produce a report with these sections:

1. Files inspected
2. Metadata found before cleanup
3. Actions taken
4. Metadata status after cleanup
5. Files that could not be inspected or cleaned
6. Remaining issues
7. Git status

State clearly that no commit was made.
