# Prompt Architecture

Shell prompts should be clear, readable, and useful in active operator workflows.

A prompt should quickly communicate:

- current user
- current directory
- current host or system identity when useful
- git repository state when relevant
- whether the shell is using a custom operator prompt or a system default prompt

## Principles

- Keep prompts readable.
- Avoid excessive symbols.
- Avoid visual noise.
- Preserve system defaults when that is the safer or more appropriate choice.
- Make prompt behavior configurable.
- Keep Bash and Zsh behavior aligned when practical.

## Prompt styles

```text
operator        custom operator prompt
system_default  preserve the system's default prompt
```

## Implementation principle

The implementation may live elsewhere, but the standard should remain documented here.

The standards repo defines what the prompt styles mean.

The dotfiles repo implements them.
