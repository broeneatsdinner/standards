# Commit Standards

This document defines commit message standards for my repositories.

## Philosophy

A commit message should describe the meaningful change, not just the files touched.

Good commits make project history readable.

A future reader should be able to scan `git log --oneline` and understand how the project evolved.

## Format

Use short, direct, sentence-case commit subjects.

Preferred:

```text
Initialize standards repository
Add core standards documentation
Update README for dotfiles architecture
Fix Bash startup detection
Refactor prompt rendering
```

Avoid noisy or vague subjects:

```text
updates
misc changes
fix stuff
wip
changes
```

## Length

Keep the subject concise.

Aim for one clear line.

If more detail is needed, use a commit body.

## Tone

Use imperative phrasing when natural.

Preferred:

```text
Add shell style documentation
Fix prompt selector fallback
Refactor SSH alias grouping
```

Also acceptable when describing a completed documentation change:

```text
Update README for dotfiles architecture
```

## Scope

A commit should usually represent one coherent change.

Good:

```text
Add script header standards
```

Less good:

```text
Add script header standards and rewrite aliases and change macOS defaults
```

## Commit body

Use a body when the reason matters, the change has risk, or the implementation needs context.

Example:

```text
Refactor prompt loading

Move prompt rendering into reusable functions so Bash and Zsh startup files
can share the same behavior without duplicating logic.
```

## Public repositories

Public repos should have especially readable commits.

Assume someone may use the commit history to understand how I work.

The commit history is part of the portfolio.

## Local/operator repositories

Local repos can move faster, but commits should still preserve intent.

Even private history should be useful to future me.

## Rule of thumb

The subject should answer:

```text
What meaningful change did this commit introduce?
```

The body, when present, should answer:

```text
Why was this change made?
```
