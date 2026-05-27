# Operator Prompt

The operator prompt is the preferred custom prompt style for personal systems and controlled environments.

## Purpose

The operator prompt should make active shell work feel clear, grounded, and consistent.

It should communicate:

- who is operating
- where they are
- what system they are on
- whether the current directory is a git repository
- whether there are meaningful git state indicators

## Tone

The prompt should feel calm, direct, and operational.

It should not be overloaded with decorative symbols.

## Example shape

```text
operator in project-name on example-host >
```

## Rules

- prioritize readability
- keep path context useful
- show host context when helpful
- show git context when inside a repo
- avoid fragile prompt logic
- keep Bash and Zsh behavior visually aligned when practical
