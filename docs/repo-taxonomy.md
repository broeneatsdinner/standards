# Repository Taxonomy

This document defines the top-level repository categories I use for public work.

A repository should make its type clear quickly.

The category should explain what kind of artifact the repository is, how polished it is expected to be, and how a reader should evaluate it.

## Top-level categories

The main repository categories are:

- Tool Repository
- Standards Repository
- Research / Lab Repository
- Field Manual Repository

These categories are not labels for decoration.

They define the operating contract of the repository.

## Tool Repository

A Tool Repository contains software meant to be run, imported, reused, or installed.

The primary artifact is the tool.

Documentation exists to explain what the tool does, how to use it, how it is organized, and how to maintain it.

A Tool Repository should make entrypoints, dependencies, configuration, tests, generated output, and examples easy to identify.

## Standards Repository

A Standards Repository defines conventions, philosophy, reusable patterns, and operational rules.

The primary artifact is the standard.

It exists so humans and machines can apply the same expectations across projects.

This repository is a Standards Repository.

A Standards Repository should be clear, stable, reusable, and easy to cite from other repositories.

## Research / Lab Repository

A Research / Lab Repository contains exploration.

It may include prototypes, notes, incomplete experiments, raw findings, comparison work, rejected approaches, or temporary scaffolding.

The primary artifact is learning.

A Research / Lab Repository can be messy while the work is still forming, but it should still explain what is being investigated and what is intentionally unfinished.

It differs from a polished Field Manual Repository because it captures investigation before the system has been made repeatable.

## Field Manual Repository

Field Manual repositories are documentation-first repositories that present repeatable real-world systems, workflows, rituals, setups, or operating practices.

A Field Manual repository is not a codebase with documentation. It is a documented system treated with the same discipline as a codebase.

The primary artifact is the operating practice.

A Field Manual Repository should make the system understandable, repeatable, and maintainable.

It may contain scripts, templates, assets, examples, checklists, or supporting code, but those files serve the documented system.

## Field Manual subtypes

### Ritual Field Manual

A Ritual Field Manual documents a repeated personal or team practice.

It explains the sequence, materials, timing, roles, constraints, and standards that make the ritual repeatable.

Example:

```text
tea-time-field-manual
```

### Expedition Field Manual

An Expedition Field Manual documents a repeatable real-world journey, visit, outing, route, or field process.

It explains preparation, logistics, route structure, decision points, observations, constraints, and after-action notes.

Example:

```text
expeditions-field-manual
```

### System Field Manual

A System Field Manual documents how a real-world setup or operating system is built and maintained.

It explains components, structure, procedures, maintenance, failure modes, and operating rules.

Example:

```text
cortado-system
```

## Differences

| Category | Primary artifact | Documentation role |
| --- | --- | --- |
| Tool Repository | Runnable or reusable software | Explains the tool |
| Standards Repository | Rules and conventions | Is the product |
| Research / Lab Repository | Learning and exploration | Captures investigation |
| Field Manual Repository | Repeatable operating practice | Is the system interface |

## Tool repositories vs Field Manual repositories

A Tool Repository is judged by whether the tool works.

A Field Manual Repository is judged by whether the documented system can be understood and repeated.

Tool repositories may include extensive documentation, but the code remains the central artifact.

Field Manual repositories may include code, scripts, or templates, but the documented practice remains the central artifact.

## Standards repositories vs Field Manual repositories

A Standards Repository defines rules that can be applied across many repositories or systems.

A Field Manual Repository documents one operating system, ritual, setup, or practice in enough detail to repeat it.

Standards are reusable authority.

Field manuals are applied operating knowledge.

## Research repositories vs Field Manual repositories

A Research / Lab Repository is for exploration before the system is settled.

A Field Manual Repository is for a practice that has been shaped into a repeatable form.

Research can contain uncertainty, alternatives, scratch work, and unfinished conclusions.

A polished field manual should reduce uncertainty for the next operator.

## Naming

Use lowercase `.md` filenames for Markdown files.

`README.md` is the only uppercase Markdown filename exception.

Good:

```text
docs/repo-taxonomy.md
docs/repo-organization.md
```

Bad:

```text
docs/Repo-Taxonomy.md
docs/repo-taxonomy.MD
```
