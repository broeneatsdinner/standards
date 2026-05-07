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
