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
templates/  reusable starting structures
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
