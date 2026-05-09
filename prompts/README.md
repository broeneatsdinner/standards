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

For example, repository OPSEC prompts use:

```text
repository-opsec-01-initiate.md
repository-opsec-02-audit.md
repository-opsec-03-remediate-text.md
repository-opsec-04-remediate-media.md
```

Script standards prompts use:

```text
script-01-initiate.md
script-02-audit.md
script-03-remediate-headers.md
script-04-remediate-content.md
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

## Numbered workflow prompt families

Use numbered workflow prompt families when a prompt set has distinct initiation, audit, and remediation phases.

Standard naming pattern:

```text
<workflow>-01-initiate.md
<workflow>-02-audit.md
<workflow>-03-remediate-<domain>.md
<workflow>-04-remediate-<domain>.md
```

The workflow prefix names the domain, such as `repository-opsec`, `filename`, or `script`.

Phase meanings:

- `01-initiate` starts the workflow, defines scope, and establishes constraints.
- `02-audit` inspects and reports only.
- `03` and `04` remediation prompts apply approved scoped changes.
- Remediation phases may include a domain suffix when the workflow has multiple remediation types, such as `text`, `media`, `headers`, or `content`.

This convention keeps phase boundaries visible in filenames, keeps initiation, audit, and remediation separate, helps AI tools infer whether a prompt is allowed to mutate files, lets humans scan the directory and understand workflow order, keeps rollback and review easier because workflows are scoped, and supports lazy-loading specialized prompts only when a task enters that workflow.

Good examples:

```text
repository-opsec-01-initiate.md
repository-opsec-02-audit.md
repository-opsec-03-remediate-text.md
repository-opsec-04-remediate-media.md

filename-01-initiate.md
filename-02-audit.md
filename-03-remediate.md

script-01-initiate.md
script-02-audit.md
script-03-remediate-headers.md
script-04-remediate-content.md
```

Do not use the numbered pattern for simple standalone helper prompts, index files like `README.md`, universal guidance files like `universal.md`, or compatibility redirect prompts.

## OPSEC prompt integration

When adding or changing an OPSEC-related standard, workflow, doctrine, or submodule, review `prompts/repository-opsec-02-audit.md`.

If the new or changed document defines an exposure surface, review step, publication workflow, asset handling procedure, or safety requirement, the repository OPSEC audit prompt should incorporate or reference it.

Any deviation should be intentional, not accidental.
