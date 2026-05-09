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
- cross-language code style standards
- graphical script header standards
- script content and comment standards
- comment and description conventions
- reusable shell components
- selector/menu conventions
- loader and terminal text-effect conventions
- color definitions and palette pairings
- typography and PDF-oriented output standards
- commit message standards
- filesystem and project-structure standards
- multi-node secure systems repository standards
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
- [docs/code-style.md](docs/code-style.md)
- [docs/media-asset-workflow.md](docs/media-asset-workflow.md)
- [docs/multi-node-repo-layout.md](docs/multi-node-repo-layout.md)
- [docs/typography.md](docs/typography.md)
- [opsec-as-systems-thinking.md](opsec-as-systems-thinking.md)
- [prompts/repository-opsec-02-audit.md](prompts/repository-opsec-02-audit.md)

## Repository OPSEC prompt architecture

The repository OPSEC workflow is intentionally ordered instead of hidden inside one large all-purpose prompt.

The prompt filenames use numeric prefixes so the sequence is visible in terminal output, editor sidebars, and GitHub file listings:

```text
repository-opsec-01-initiate.md
repository-opsec-02-audit.md
repository-opsec-03-remediate-text.md
repository-opsec-04-remediate-media.md
```

That ordering makes the workflow clean and coherent to both humans and machines.

The architecture separates three responsibilities:

- initiation establishes the publication context and operating constraints
- audit inspects the repository and produces a report only
- remediation happens later through approved, scoped follow-up prompts

The audit phase does not mutate files.

It does not redact, rewrite, delete, move, rename, commit, publish, or otherwise repair anything automatically.

Remediation requires a separate human-approved instruction with clear scope.

This avoids:

- silent mutation
- review bypass
- one giant magic prompt behavior
- ambiguity about whether the AI has authority to change the repository

The point is not to claim operational maturity.

The workflow demonstrates it: discovery, assessment, approval, and repair are separate phases with visible boundaries.

## Project initialization

Use `prompts/project-initialization.md` as the entrypoint for new projects, repository work, Codex sessions, and ChatGPT coding threads.

That file includes the standard first prompt to paste at the start of a new ChatGPT or Codex session.

That prompt locates the standards repository, reads the relevant standards cascade, and establishes the operating rules before edits begin.

## Directory structure

```text
standards/
├── README.md
├── docs/
├── prompts/
├── shell/
├── directory_structures/
├── examples/
└── assets/
```

## Directory meanings

```text
docs/
    written standards, rationale, conventions, and human-readable authority

prompts/
    AI-facing prompt material that tells assistants how to apply the standards

shell/
    reusable implementation components, helpers, loaders, colors, headers,
    selectors, and text effects

directory_structures/
    starting structures, project skeletons, and reusable filesystem layouts

examples/
    working examples that demonstrate the standards in practice

assets/
    visual reference assets such as ANSI art, ASCII art, screenshots, palette
    references, typography fixtures, and other supporting media
```

The `docs/` directory is the canonical authority for written standards. The `prompts/` directory should point AI tools at those standards and explain how to apply them. The `shell/` directory contains reusable implementation pieces. The `directory_structures/` directory contains example or starter filesystem layouts that can be copied, adapted, or used as references.

`assets/typography/` contains reusable chat and document rendering fixtures for Markdown-to-HTML/PDF workflows.

## Current populated areas

```text
docs/
    core written standards

prompts/
    AI prompt standards and publication-audit workflows

shell/
    initial reusable shell component stubs

directory_structures/
    starter structures and reusable layouts for common project types

assets/
    typography fixtures and visual reference assets
```

The `examples/` directory is intentionally present as a planned expansion area.

## Core principle

A well-structured system should not require explanation.

If explanation is required, the structure is part of the problem.
