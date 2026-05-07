# Prompts

This directory contains AI-assistant prompts and instructions for applying this repository's standards.

Shell prompt standards are not kept here. They live under:

```text
shell/prompts/
```

This keeps AI prompts separate from PS1/shell prompt standards.

## Operational prompt requirements

Any operational prompt file in this directory that tells Codex or another AI assistant to perform a specific task must include a near-top section called `Invocation instructions`.

The `Invocation instructions` section must contain copy/paste-ready text for running that prompt against the current repository.

Prompts that explain baseline behavior, directory purpose, or general guidance do not need `Invocation instructions`.

## Ordered prompt workflows

Some prompt sets are numbered because they represent an ordered operational workflow.

For example, publication OPSEC prompts use:

```text
publication-opsec-01-initiate.md
publication-opsec-02-audit.md
publication-opsec-03-remediate-text.md
publication-opsec-04-remediate-media.md
```

The number indicates workflow order.

The name after the number indicates the phase.

`01-initiate` prompts establish scope, intent, and authority boundaries.

`02-audit` prompts report findings without changing repository state.

`03` and later remediation modules should use imperative `remediate-*` names, with `remediate` reserved for a single general remediation authority in a workflow family.

Each number must be unique within a workflow family.

Remediation modules represent specific approved mutation authorities, such as `remediate-text`, `remediate-media`, or `remediate` for a narrowly scoped workflow.

Remediation prompts make approved, scoped changes after human review.

This keeps workflow control, audit, and repair separate while making the sequence readable to both humans and AI systems.

## OPSEC prompt integration

When adding or changing an OPSEC-related standard, workflow, doctrine, or submodule, review `prompts/publication-opsec-02-audit.md`.

If the new or changed document defines an exposure surface, review step, publication workflow, asset handling procedure, or safety requirement, the publication audit prompt should incorporate or reference it.

Any deviation should be intentional, not accidental.
