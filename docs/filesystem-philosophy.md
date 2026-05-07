# Filesystem Philosophy

I design systems so that structure is predictable, navigation is immediate, and intent is visible from the directory layout alone.

If you drop me into any system, I will determine where everything is, where it should be, and how to organize it so teams do not get lost.

The goal is not rigid structure for its own sake.

The goal is eliminating ambiguity.

## Core principles

- Structure should make intent visible.
- Important paths should become obvious quickly.
- Humans should not need tribal knowledge to navigate a system.
- Tools should be able to rely on predictable locations.
- Generated files, temporary files, logs, source files, configuration, and public entrypoints should not be mixed together.

## Operator approach

When entering an unfamiliar system:

1. Observe the existing layout.
2. Identify what is intentional and what is accidental.
3. Map where code, configuration, data, logs, generated output, and entrypoints live.
4. Identify inconsistencies and naming drift.
5. Define a cleaner structure.
6. Refactor toward that structure with minimal disruption.

## Standard directory meanings

```text
bin/      user-facing commands and executable entrypoints
shell/      reusable sourced/imported components
scripts/  internal helper scripts
docs/     documentation and standards
examples/ working examples and reference implementations
assets/   static visual/media/reference assets
config/   configuration files
data/     input data
output/   generated output
logs/     runtime logs
tmp/      temporary files safe to delete
```

## Web project layout

For website deployments, the preferred server-side layout is domain-first:

```text
domain.name/
├── html/
│   ├── index.html
│   ├── index.php
│   └── _/
│       ├── css/
│       ├── js/
│       ├── php/
│       ├── assets/
│       └── includes/
├── logs/
├── backups/
└── config/
```

The `html/` directory is the public web root.

The `html/_/` directory is the organized internal namespace for supporting website files.

The root of `html/` should stay clean and should primarily contain public entrypoints.

## Shell project layout

```text
project-name/
├── README.md
├── bin/
├── shell/
├── scripts/
├── docs/
├── examples/
├── logs/
└── tmp/
```

`bin/` is for user-facing commands.

`shell/` is for reusable sourced components.

`scripts/` is for internal helpers.

`logs/` and `tmp/` should be safe to remove or regenerate.

## Python project layout

```text
project-name/
├── README.md
├── requirements.txt
├── src/
│   └── project_name/
├── scripts/
├── docs/
├── tests/
├── data/
├── output/
├── logs/
└── tmp/
```

Importable Python code belongs under `src/`.

Runnable helper scripts belong under `scripts/`.

Input data, generated output, logs, and temporary files should remain separated.

## Rule of thumb

A well-structured system should not require explanation.

If explanation is required, the structure is part of the problem.

## Underscore support directory

The `_` directory is a project-local support namespace.

It holds files that support public or root-level entrypoints but should not clutter the root of the project or web directory.

This convention is especially useful for website projects, but may also apply to other project types.

Example web layout:

```text
html/
├── index.html
└── _/
    ├── css/
    ├── js/
    ├── php/
    ├── python/
    ├── assets/
    └── includes/
```

Example project layout:

```text
project-name/
├── README.md
├── main.sh
└── _/
    ├── shell/
    ├── python/
    ├── data/
    ├── output/
    └── assets/
```

The `_` directory should make support files easy to find while keeping top-level entrypoints clean.

This section is a placeholder for a fuller standard.
