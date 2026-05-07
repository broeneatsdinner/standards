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

## OPSEC prompt integration

Publication OPSEC workflow prompts use numbered filenames when execution order matters:

```text
publication-opsec-01-initiate.md
publication-opsec-02-audit.md
publication-opsec-03-media-remediation.md
```

The number encodes the intended workflow position so terminal and GitHub file listings show the pipeline order naturally.

When adding or changing an OPSEC-related standard, workflow, doctrine, or submodule, review `prompts/publication-opsec-02-audit.md`.

If the new or changed document defines an exposure surface, review step, publication workflow, asset handling procedure, or safety requirement, the publication audit prompt should incorporate or reference it.

Any deviation should be intentional, not accidental.
