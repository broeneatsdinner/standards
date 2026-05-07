# Operational Audits

This document defines operational audit categories for repository governance.

It is the audit-domain layer above specific prompt workflows.

It complements [Workflow Architecture](workflow-architecture.md), which defines the general phase model:

```text
initiation
    ->
audit
    ->
remediation
```

Workflow architecture explains how work moves through phases.

Operational audits explain what kind of review is being performed.

## Core doctrine

An operational audit is a scoped repository inspection.

It reviews one domain of repository behavior and reports findings without changing repository state.

Audits may inspect files, filenames, metadata, references, publication surfaces, prompt behavior, generated artifacts, or repository structure.

By default, an audit is report-only.

It does not rename, normalize, rewrite, redact, delete, move, publish, commit, or repair files.

This boundary preserves the human review point.

Audit findings become remediation scope only after a human approves the finding, the change, and the affected files or behaviors.

## Relationship to workflow architecture

Operational audits sit inside the audit phase of the workflow model.

Initiation defines the operating frame.

Audit inspects and reports within that frame.

Remediation changes repository state only after approval.

In numbered prompt workflows, `01-initiate` establishes scope, `02-audit` reports findings, and `03` or later remediation modules perform approved mutation work.

Numbers must be unique within a workflow family.

Remediation modules should use imperative `remediate-*` names when they represent specific mutation authorities.

Use `remediate` only when the workflow family has a single general remediation authority.

Each remediation module represents a specific approved mutation authority.

Example:

```text
publication initiation
    ->
OPSEC audit + filename audit + publication audit
    ->
approved redaction, rename, or reference update
```

The audit category does not grant remediation authority.

It only defines the review domain.

## Audit categories

### OPSEC audits

OPSEC audits review exposure risk.

They look for information that should not be published, such as private paths, local usernames, secrets, tokens, internal hostnames, personal metadata, sensitive screenshots, unintentional provenance, or unnecessary identifying detail.

An OPSEC audit may recommend redaction, omission, metadata stripping, or publication delay.

It does not perform those changes by default.

Example finding:

```text
docs/example.md references a local absolute path under /Users/name.
Recommended remediation: replace with a neutral example path after approval.
```

### Filename audits

Filename audits review naming, casing, extensions, and path clarity.

They look for uppercase Markdown filenames, inconsistent extensions, vague directory names, extension/content mismatches, and filenames that obscure repository purpose.

A filename audit may identify normalization candidates.

It does not rename files by default.

Example finding:

```text
docs/Guide.MD does not match the lowercase Markdown filename standard.
Recommended remediation: rename to docs/guide.md and update references after approval.
```

### Normalization audits

Normalization audits review whether repository artifacts conform to established standards.

They may inspect Markdown conventions, directory layout, script headers, shell style, comments, selectors, media organization, or reusable component structure.

Normalization can appear mechanical, but it can affect links, imports, generated output, public URLs, and tool behavior.

For that reason, normalization findings require explicit remediation approval.

Example finding:

```text
scripts/build lacks the standard script header.
Recommended remediation: add the header pattern used by this repository after approval.
```

### Repository hygiene audits

Repository hygiene audits review maintainability and navigability.

They look for generated files committed by accident, stale temporary output, unclear archive directories, duplicate files, missing README context, broken references, inconsistent organization, or artifacts that no longer serve the repository.

A hygiene audit may recommend cleanup.

It does not delete, reorganize, or rewrite repository structure by default.

Example finding:

```text
tmp/output.log appears to be runtime output.
Recommended remediation: remove it from version control and update .gitignore after approval.
```

### Publication audits

Publication audits review whether a repository or artifact is ready to be public.

They combine public readability, OPSEC, filename safety, reference integrity, license expectations, generated artifact status, and publication intent.

Publication audits are especially useful before pushing a public branch, opening a pull request, tagging a release, publishing documentation, or moving local work into a public standards repository.

Publication audit findings should distinguish between blockers, recommended cleanup, and acceptable tradeoffs.

Example finding:

```text
README.md explains purpose and usage, but docs/example.md links to a file that is not present.
Recommended remediation: add the missing file or remove the link after approval.
```

### Future AI governance workflows

AI governance audits review assistant authority, prompt scope, workflow boundaries, and human approval points.

They look for prompts or procedures that combine initiation, audit, remediation, publication, committing, or deletion in one ambiguous workflow.

They also review whether AI instructions make report-only boundaries and approval requirements clear.

These audits help prevent silent mutation, review bypass, and unclear AI authority as new workflows are added.

Example finding:

```text
prompts/repo-cleanup.md instructs the assistant to inspect and fix issues in one step.
Recommended remediation: split the prompt into audit and remediation phases after approval.
```

## Domain boundaries

Audit domains overlap, but they are not interchangeable.

An OPSEC issue concerns exposure.

A filename issue concerns naming and path behavior.

A normalization issue concerns conformance to standards.

A hygiene issue concerns maintainability and repository shape.

A publication issue concerns public readiness.

An AI governance issue concerns authority boundaries and assistant behavior.

The same file can appear in multiple audit reports for different reasons.

Example:

```text
docs/PrivateNotes.MD
```

This path may produce:

- an OPSEC finding because it contains personal detail
- a filename finding because the casing is nonstandard
- a publication finding because it should not ship publicly

Those findings should remain distinct until remediation is approved.

## Composed audits

Audit categories can compose before publication.

A publication review may run several audits together:

```text
OPSEC audit
filename audit
normalization audit
repository hygiene audit
publication audit
```

Composition does not collapse authority boundaries.

Each audit still reports findings.

Each remediation still requires human approval.

This allows a human operator to decide, for example, to approve filename normalization but defer OPSEC-sensitive redaction until more context is available.

## Human and AI safety

Operational audit architecture makes repository review legible.

Humans can see what domain is being inspected, what was found, and what changes are being requested.

AI assistants can operate inside a narrower contract instead of guessing whether they have authority to mutate repository state.

This reduces:

- silent mutation
- review bypass
- accidental publication changes
- ambiguous AI authority
- mixed discovery and repair
- broad prompts that do too much

The result is not slower work.

It is clearer work.

Findings create a decision surface.

Remediation acts on approved decisions.
