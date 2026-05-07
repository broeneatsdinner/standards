# Filename Initiation Prompt

Use this prompt when starting a filename, directory-name, or extension-normalization workflow for a repository.

The goal is to establish repository context, define the naming-review scope, determine whether normalization is appropriate, and recommend the next workflow phase.

Do not modify files.

Do not commit anything.

## Invocation instructions

Copy and paste this into Codex to start the filename workflow against the current repository:

```text
Please use prompts/filename-01-initiate.md as your operating prompt and apply it to this repository.

This is the initiation phase for a filename workflow.

Establish the repository context, publication context, and filename-review scope.

Use docs/workflow-architecture.md and docs/media-asset-workflow.md as workflow context.

Determine whether filename or extension normalization is appropriate for this repository, but do not perform an audit or remediation yet.

Do not rename, normalize, move, rewrite, delete, edit, publish, or commit anything.

After initiation, show me:

- repository type and apparent publication context
- proposed filename and directory audit scope
- whether media extension/content checks should be included
- whether normalization appears appropriate to evaluate
- whether prompts/filename-02-audit.md should be run next
- whether any remediation should be deferred until after audit findings and explicit human approval
- recommended next steps
- confirmation that you did not modify or commit anything
```

## Task

Start the filename workflow for the current repository.

Identify what kind of repository this is, what public or operational boundary appears to apply, and what filename, directory-name, and extension surfaces should be reviewed.

Produce a workflow plan only.

## Required references

Use these files as operating context:

- `docs/workflow-architecture.md`
- `docs/media-asset-workflow.md`
- `prompts/filename-02-audit.md`
- `prompts/filename-03-remediate.md`

Use `docs/workflow-architecture.md` to preserve the initiation -> audit -> remediation sequence.

Use `docs/media-asset-workflow.md` to identify media filename, extension, MIME/type, curation, and publication-review expectations.

Use `prompts/filename-02-audit.md` as the next report-only audit phase.

Use `prompts/filename-03-remediate.md` only as a possible follow-up mutation phase after findings are reviewed and explicitly approved.

## Repository and publication context

Identify the repository type when possible.

For public standards repositories, treat filenames and prompt names as part of the public interface.

For documentation-first repositories, treat Markdown paths, asset paths, links, previews, static-site output, and examples as downstream surfaces.

For media-heavy repositories, apply the public asset guidance in `docs/media-asset-workflow.md`, including descriptive public-safe names and truthful extensions.

Do not assume every local file is intended for publication.

Flag unclear publication boundaries as planning issues.

## Scope planning

Recommend an audit scope that may include:

- maintained source files
- documentation files
- prompt files
- public media assets
- asset folders
- examples and templates
- README files
- indexes, manifests, generated references, or build paths when maintained by the repository

Identify surfaces that should normally be excluded or handled cautiously:

- vendored files
- generated files
- dependency folders
- caches
- build output
- archives
- third-party source copies
- ignored private intake folders

If excluded files appear to be maintained source artifacts, report that uncertainty.

## Normalization decision

Determine whether filename, directory-name, or extension normalization appears appropriate to evaluate.

Do not perform normalization during initiation.

Normalization is remediation.

Filename normalization can affect:

- links
- imports
- documentation references
- static-site output
- deployment paths
- external URLs
- screenshots
- manifests
- cache behavior
- downstream automation

Changing a media extension can affect MIME detection, previews, build tooling, publication behavior, and external references.

Recommend normalization only as a possible follow-up after report-only audit findings and explicit human approval.

## Workflow direction

Recommend running `prompts/filename-02-audit.md` for the report-only audit phase when filename, directory-name, extension, MIME/type, or reference impacts need inspection.

Recommend `prompts/filename-03-remediate.md` only after:

- audit findings exist
- a human has reviewed the findings
- the human has explicitly approved remediation
- the remediation scope is clear

The audit phase must not modify files.

The remediation phase may mutate repository state only inside the approved scope.

## Safety constraints

Do not edit files.

Do not delete files.

Do not rename files.

Do not move files.

Do not normalize filenames or extensions.

Do not rewrite references.

Do not publish anything.

Do not commit anything.

Do not run audit or remediation during initiation.

## Report format

Produce a report with these sections:

1. Repository context and publication intent
2. Publication or maintenance boundary
3. Proposed audit scope
4. Normalization suitability
5. Recommended workflow plan
6. Remediation boundary
7. Limitations
8. Confirmation

The workflow plan should be ordered and practical.

State clearly whether `prompts/filename-02-audit.md` should be run next.

Confirm that no files were modified and no commits were made.
