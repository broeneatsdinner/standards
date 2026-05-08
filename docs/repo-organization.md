# Repo Organization

This document defines repository organization standards.

## Philosophy

A repository should reveal its purpose quickly.

A reader should be able to open the repo, scan the top-level files and directories, and understand the project shape.

## Standard top-level files

Common top-level files:

```text
README.md
.gitignore
LICENSE
```

Use only what the project needs.

Do not add boilerplate files that do not serve a real purpose.

## Standard top-level directories

Common project directories:

```text
docs/       documentation
shell/        reusable code
bin/        user-facing commands
scripts/    internal helper scripts
examples/   example usage
assets/     visual/static/reference assets
tests/      tests
data/       input data
output/     generated output
logs/       runtime logs
tmp/        temporary files
config/     configuration
prompts/    AI assistant prompts and instructions
directory_structures/  reusable starting structures
```

## Public repositories

Public repositories should be especially clear.

They should explain:

- what the project is
- why it exists
- what problem it solves
- how it is organized
- how to run or use it
- what is intentionally excluded

A public repo is both a tool and a portfolio artifact.

## Private or local repositories

Private repositories can be more operational, but they should still be navigable.

Future me is also a user.

## README standards

A README should usually include:

```text
project name
short description
purpose
usage
directory structure
notes or philosophy
```

For small helper repositories, keep the README direct.

For public portfolio repositories, include enough context to show how the project reflects the work.

## Directory structure documentation

If a repo has an intentional structure, document it.

Example:

```text
project-name/
├── README.md
├── bin/
├── shell/
├── docs/
└── examples/
```

Then explain what each directory means.

## Naming

Use clear lowercase names for directories unless the ecosystem has a strong convention otherwise.

README.md is the intentional conventional exception for Markdown filenames.

All other Markdown files should use lowercase filenames with a lowercase `.md` extension.

Good:

```text
README.md
shell-style.md
differentiator.md
```

Bad:

```text
DIFFERENTIATOR.MD
Differentiator.md
differentiator.MD
```

Prefer:

```text
docs/
scripts/
examples/
```

Avoid unclear names:

```text
misc/
stuff/
old/
new/
```

If an archive or legacy directory is needed, make its purpose explicit.

Examples:

```text
archive/
legacy/
reference/
```

## Generated files

Generated files should be separated from source files.

Use directories such as:

```text
output/
logs/
tmp/
```

Generated files should usually be ignored unless they are meaningful artifacts.

## Rule of thumb

A repository should answer the first question immediately:

```text
Where am I, and what matters here?
```

## Repository description

Every public repository should have a GitHub repository description.

The description should be one short sentence that explains what the repo is and why it exists.

It should be specific enough to orient a visitor before they open the README.

Good descriptions are:

- short
- specific
- plain-language
- project-focused
- useful without additional context

Avoid descriptions that are vague, cute, empty, or overly broad.

Good:

```text
Public standards, reusable shell components, prompt guidance, and operator-style conventions for my tools, dotfiles, automation workflows, and project ecosystems.
```

Avoid:

```text
My stuff
Misc tools
Personal repo
Experiments
```
