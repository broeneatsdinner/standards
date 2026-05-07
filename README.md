# standards

Public standards, reusable shell components, prompt guidance, and operator-style conventions for my local tools, helper applications, dotfiles, security workflows, publication workflows, and project ecosystems.

This repository can look like a collection of shell and repository style guides at first glance.

It is broader than that.

It is a codified operational architecture for documenting, reviewing, publishing, and maintaining technical systems with both human and AI operators in mind.

This repository exists to:

- show how I think and work
- keep projects visually and operationally consistent
- define reusable shell components
- define script, documentation, commit, prompt, and directory-structure standards
- define publication, audit, and OPSEC review practices
- give AI coding tools a canonical source for applying my style
- maintain a cohesive view of my projects and operating patterns

## Philosophy

I impose structure on systems so they are immediately navigable, maintainable, and operable by humans and by machines.

If you drop me into any system, I will determine where everything is, where it should be, and how to organize it so teams do not get lost.

The goal is not rigid structure for its own sake.

The goal is eliminating ambiguity.

## What this repo contains

- shell style standards
- graphical script header standards
- comment and description conventions
- reusable shell components
- selector/menu conventions
- loader and terminal text-effect conventions
- color definitions and palette pairings
- commit message standards
- filesystem and project-structure standards
- shell prompt standards
- AI prompt guidance for applying these standards
- repository audit and refactor guidance
- repository taxonomy
- media asset publication workflow
- OPSEC methodology
- publication audit prompts
- operational standards authority for other projects
- examples and reusable patterns

These pieces are meant to connect:

```text
taxonomy
    ->
workflow standards
    ->
naming conventions
    ->
publication pipelines
    ->
OPSEC methodology
    ->
audit prompts
    ->
AI-operational prompts
    ->
repository publication systems
```

Most repositories stop at one layer: a style guide, a naming convention, a prompt snippet, an OPSEC checklist, or documentation advice.

This repository connects those layers into a repeatable operating system.

It documents how systems should be documented, reviewed, operationalized, and safely published.

## Operational standards authority

This repo is not just documentation.

It is a reusable operational standards authority.

That means:

- humans can read it
- AI coding tools can consume it
- future repos can reference it
- reusable shell components can be imported from it
- audits and refactors can be standardized against it
- project-structure decisions have a canonical source

In practice, this repo functions as personal engineering standards infrastructure.

This level of centralized engineering standards infrastructure is more commonly found in mature engineering organizations with dedicated platform, tooling, or developer-experience functions.

This repository applies the same operational thinking at an individual scale.

See [differentiator.md](differentiator.md) for why this repository matters as a public portfolio artifact.

For concrete examples of the operating architecture, see:

- [docs/repo-taxonomy.md](docs/repo-taxonomy.md)
- [docs/media-asset-workflow.md](docs/media-asset-workflow.md)
- [opsec-as-systems-thinking.md](opsec-as-systems-thinking.md)
- [prompts/publication-opsec-audit.md](prompts/publication-opsec-audit.md)

## Directory structure

```text
standards/
├── README.md
├── docs/
├── shell/
├── prompts/
├── examples/
├── assets/
└── templates/
```

## Directory meanings

```text
docs/       written standards, philosophy, and conventions
shell/      reusable shell components such as colors, headers, loaders, selectors, text effects, and shell prompts
prompts/    AI-assistant prompts for applying these standards
examples/   working examples that demonstrate the standards in practice
assets/     visual reference assets such as ANSI art, ASCII art, screenshots, and palette references
templates/  starter directory and file structures for common project types
```

## Current populated areas

```text
docs/       core written standards
shell/      initial reusable shell component stubs
prompts/    AI prompt standards
```

The `examples/`, `assets/`, and `templates/` directories are intentionally present as planned expansion areas.

## Core principle

A well-structured system should not require explanation.

If explanation is required, the structure is part of the problem.
