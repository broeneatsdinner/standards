# Filename Audit Prompt

Deprecated compatibility redirect.

The filename workflow now follows the repository workflow architecture:

```text
initiation -> audit -> remediation
```

Use the numbered workflow prompts instead:

- `prompts/filename-01-initiate.md`
- `prompts/filename-02-audit.md`
- `prompts/filename-03-remediation.md`

This file remains only so older instructions that reference `prompts/filename-audit.md` do not fail silently.

For new work, use `prompts/filename-01-initiate.md` to establish scope or `prompts/filename-02-audit.md` when the audit scope has already been approved.

## Invocation instructions

Copy and paste this into Codex when an older workflow tells you to use `prompts/filename-audit.md`:

```text
Please use prompts/filename-02-audit.md as your operating prompt and apply it to this repository.

This invocation came from the deprecated prompts/filename-audit.md compatibility redirect.

This is the audit phase for a filename workflow.

Audit the repository for filename and directory naming violations.

Use docs/workflow-architecture.md and docs/media-asset-workflow.md as workflow context.

This is a report-only audit.

Do not rename, normalize, move, rewrite, delete, edit, publish, or commit anything.

Identify findings and remediation candidates only.

Recommend follow-up remediation workflows where appropriate.

After the audit, show me:

- filename and directory findings
- extension/content mismatches or MIME/type inconsistencies
- candidate remediations
- references and downstream systems that would need updates during remediation
- unsafe or uncertain remediation candidates
- recommended follow-up workflow
- git status
- confirmation that you did not mutate the repository

Pay special attention to Markdown filename standards.
```

## Task

Do not treat this file as the authoritative filename audit workflow.

Use `prompts/filename-02-audit.md`.

If scope, repository context, or normalization authority is unclear, start with `prompts/filename-01-initiate.md`.

If a human has reviewed audit findings and explicitly approved a scoped mutation, use `prompts/filename-03-remediation.md`.

Do not mutate the repository from this compatibility redirect.
