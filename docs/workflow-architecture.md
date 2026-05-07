# Workflow Architecture

This document defines the repository workflow architecture doctrine.

The standards repository uses a generalized operational workflow model:

```text
initiation
    ->
audit
    ->
remediation
```

This model applies across publication OPSEC workflows, filename auditing workflows, normalization workflows, and other repository-maintenance procedures that involve human review and AI-assisted execution.

The model is not ceremony.

It is operational governance for repository safety, publication control, workflow clarity, and human/AI collaboration.

## Core doctrine

Repository workflows should separate discovery, authority, review, and mutation.

A workflow that finds a problem should not automatically repair the problem unless it has been explicitly authorized to do so.

A workflow that changes repository state should have clear scope, clear approval, and a clear relationship to prior findings.

This reduces:

- silent mutation
- review bypass
- unclear publication authority
- accidental normalization
- ambiguous AI authority
- oversized all-purpose prompt behavior
- hidden coupling between inspection and repair

## Workflow phases

### Initiation

Initiation establishes scope, intent, and authority boundaries.

An initiation workflow answers:

- what kind of repository is being reviewed
- what the operator is trying to accomplish
- what publication or maintenance boundary applies
- what should be inspected next
- what must not be changed yet
- what follow-up workflow is appropriate

Initiation is especially important when the repository contains mixed concerns, such as documentation, scripts, prompts, media, examples, and publication artifacts.

The initiation phase prevents the AI assistant from assuming that local presence means publication intent.

It also prevents the assistant from treating a broad request as authority to audit, rewrite, normalize, redact, publish, commit, or reorganize in one step.

Initiation defines the operating frame before inspection begins.

### Audit

Audit is report-only.

An audit workflow inspects the repository and produces findings.

It may identify:

- risks
- inconsistencies
- naming violations
- exposure surfaces
- metadata issues
- extension/content mismatches
- references that would be affected by remediation
- recommended follow-up work

An audit does not mutate the repository.

It does not rename, normalize, rewrite, redact, delete, move, publish, commit, or repair files.

This boundary matters because audit findings require human judgment.

Some findings are defects.

Some findings are acceptable tradeoffs.

Some apparent issues are intentional local conventions.

Some remediations would affect public URLs, imports, references, generated output, media provenance, or publication meaning.

Keeping audits report-only preserves the review point where a human can decide what should happen.

### Remediation

Remediation is the approved mutation phase.

Remediation happens only after:

- an audit or review has identified the issue
- a human has reviewed the finding
- the human has explicitly approved the change
- the remediation scope is clear

Remediation workflows may edit, rename, normalize, redact, move, delete, regenerate, or otherwise change repository state, but only within the approved scope.

The remediation phase should preserve traceability back to the finding or decision that authorized the change.

When a remediation has downstream effects, it should update affected references and verify the result.

## Discovery is not remediation

Discovery identifies what exists.

Normalization and remediation change what exists.

Those are different authorities.

Filename discovery may reveal uppercase Markdown files, vague directories, or extension/content mismatches.

That does not mean the workflow is authorized to rename them.

Publication discovery may reveal private paths, media metadata, or unnecessary personal detail.

That does not mean the workflow is authorized to redact, delete, strip metadata, or rewrite history.

Discovery creates a decision surface.

Remediation acts on a decision.

Keeping those separate makes repository state changes intentional instead of incidental.

## Normalization is separate from audit

Normalization is a specific kind of remediation.

It makes repository artifacts conform to a preferred standard, such as canonical filename casing, preferred extensions, or consistent directory naming.

Normalization can look mechanical, but it is not always safe.

Renaming a file can affect:

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

For that reason, normalization should not be hidden inside discovery or metadata review.

It should be approved as an explicit remediation workflow with affected references updated and verified.

## Sequencing matters

Workflow order is operationally meaningful.

The sequence:

```text
initiation -> audit -> remediation
```

creates checkpoints.

Initiation establishes context before inspection.

Audit produces findings before mutation.

Remediation acts only after approval.

Changing the order weakens the control model.

If remediation happens during audit, the human review point is bypassed.

If audit happens without initiation, the assistant may inspect the wrong surfaces or assume the wrong publication boundary.

If normalization happens during discovery, file changes may appear as incidental cleanup instead of approved repository mutation.

Visible sequencing also helps humans and AI systems understand where they are in the workflow.

Numbered prompt workflows, explicit phase names, and report-only language make the operating state legible in terminal output, editor sidebars, GitHub file listings, and conversation history.

Within a workflow family, numbers must be unique and preserve the operating sequence.

Use `01-initiate` for the initiation prompt that establishes scope.

Use `02-audit` for the report-only prompt that produces findings.

Use `03` and later numbers for remediation modules, named imperatively as `remediate-*` when the workflow has specific mutation authorities.

Use `remediate` only when the workflow family has a single general remediation authority.

Each remediation module represents a specific approved mutation authority, such as text redaction, media metadata cleanup, filename normalization, or reference updates.

## Operational governance

This architecture treats workflow phases as governance boundaries.

The point is not to slow work down.

The point is to make authority explicit.

Audits are allowed to inspect and report.

Remediation is allowed to change only what was approved.

Initiation is allowed to recommend scope and sequence.

Each phase has a different operating contract.

That contract protects the repository from accidental state changes and protects the human operator from unclear assistant behavior.

## Repository safety

Repository safety depends on predictable mutation.

The workflow model makes repository changes:

- scoped
- reviewable
- attributable
- reversible when practical
- separated from discovery
- tied to explicit approval

This matters for both small naming cleanups and high-risk publication reviews.

The same architecture that prevents an AI assistant from silently redacting OPSEC findings also prevents it from silently renaming files during a filename audit.

The shared principle is that inspection does not imply write authority.

## Publication control

Publication workflows require extra control because repository contents may expose private, personal, operational, or security-sensitive information.

Publication OPSEC review should therefore preserve a clean distinction between:

- understanding what the repository is
- auditing what it exposes
- deciding what should change
- remediating approved findings
- publishing only after review

This prevents a single prompt from becoming a combined auditor, editor, redactor, publisher, and committer.

Publication control requires visible decision points.

The repository should not drift toward public release through automatic cleanup.

It should move toward publication through deliberate review and approved remediation.

## Human/AI collaboration

AI assistants need clear authority boundaries.

Without those boundaries, an assistant may interpret a request to inspect as permission to repair, normalize, redact, or reorganize.

The initiation, audit, and remediation model gives the assistant a stable collaboration structure:

- initiation clarifies the job
- audit reports what it found
- remediation performs approved work

This structure helps the human operator stay in control while still allowing AI assistance to do useful work.

It also makes prompt behavior easier to reason about, reuse, and review across repositories.

## Current applications

This architecture currently governs:

- publication OPSEC workflows
- filename auditing workflows
- extension and filename normalization workflows

It should be used for future repository workflows when the work involves inspection, judgment, approval, and mutation.

## Rule of thumb

Do not combine discovery and mutation unless the human has explicitly approved that combined authority.

If a workflow finds something, report it.

If a workflow changes something, make sure the change was authorized.
