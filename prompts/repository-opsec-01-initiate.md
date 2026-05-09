# Repository OPSEC Initiation Prompt

Use this prompt when starting publication review for a repository.

The goal is to identify the repository type, clarify publication intent, and produce a recommended workflow plan.

Do not modify files.

Do not commit anything.

## Invocation instructions

Copy and paste this into Codex to start the repository OPSEC workflow against the current repository:

```text
Please use prompts/repository-opsec-01-initiate.md as your operating prompt and apply it to this repository.

This is the initiation phase for a repository OPSEC review.

Identify the repository type and publication intent.

Use docs/repo-taxonomy.md, docs/media-asset-workflow.md, opsec-as-systems-thinking.md, and prompts/repository-opsec-02-audit.md as workflow context.

Do not modify, delete, rename, move, redact, rewrite, publish, or commit anything.

Produce a recommended workflow plan.

After initiation, show me:

- repository type
- apparent publication intent
- relevant exposure surfaces
- recommended audit scope
- whether prompts/repository-opsec-02-audit.md should be run next
- whether any remediation should be deferred until after audit findings and explicit human approval
- recommended next steps
- confirmation that you did not modify or commit anything
```

## Task

Start the repository OPSEC workflow for the current repository.

Identify what kind of repository this is, what public artifact it appears to present, and what review path should be used before publication.

Produce a workflow plan only.

## Required references

Use these files as operating context:

- `docs/repo-taxonomy.md`
- `docs/media-asset-workflow.md`
- `opsec-as-systems-thinking.md`
- `prompts/repository-opsec-02-audit.md`

Use `docs/repo-taxonomy.md` to identify the repository type.

Use `docs/media-asset-workflow.md` to identify media intake, curation, metadata, and publication-review expectations.

Use `opsec-as-systems-thinking.md` to frame risk as a system-level exposure problem, not only a secret-scanning problem.

Use `prompts/repository-opsec-02-audit.md` as the next report-only audit phase.

## Repository classification

Classify the repository using the taxonomy when possible:

- Tool Repository
- Standards Repository
- Research / Lab Repository
- Field Manual Repository

If the repository appears to mix categories, identify the primary category and any secondary traits.

Explain how the repository type affects publication risk.

## Publication intent

Infer publication intent from the README, documentation, repository structure, prompts, examples, assets, and working tree.

Identify whether the repository appears intended to publish:

- reusable standards
- runnable tools
- research notes
- field manuals
- media assets
- examples or templates
- personal operating doctrine
- other public artifacts

Do not assume every local file is meant for publication.

Flag unclear publication boundaries as planning issues.

## Workflow direction

Recommend running `prompts/repository-opsec-02-audit.md` for the report-only audit phase.

The audit phase should inspect repository content, filenames, links, media, metadata, raw/private asset paths, and git history where possible.

Media-heavy repositories may need the numbered contact-sheet workflow from `docs/media-asset-workflow.md` before remediation.

For large image sets, recommend private contact sheets with stable integer identifiers, original filenames, and local number-to-filename indexes so audit findings and human approvals can refer to assets clearly.

Those review artifacts should remain private and ignored unless intentionally sanitized for publication.

The audit phase must not modify files.

Remediation must happen only after:

- the audit report exists
- a human has reviewed the findings
- the human has explicitly approved remediation
- the remediation scope is clear

Use separate scoped remediation prompts for follow-up work:

- `prompts/repository-opsec-03-remediate-text.md` for approved text and documentation remediation
- `prompts/repository-opsec-04-remediate-media.md` for approved curated-media remediation

## Safety constraints

Do not edit files.

Do not delete files.

Do not rename files.

Do not move files.

Do not redact files.

Do not rewrite history.

Do not commit anything.

Do not publish anything.

Do not run remediation during initiation.

Do not treat initiation as audit completion.

## Report format

Produce a report with these sections:

1. Repository type
2. Publication intent
3. Exposure surfaces
4. Recommended audit scope
5. Recommended workflow plan
6. Remediation boundary
7. Limitations
8. Confirmation

The workflow plan should be ordered and practical.

State clearly whether `prompts/repository-opsec-02-audit.md` should be run next.

Confirm that no files were modified and no commits were made.
