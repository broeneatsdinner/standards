# AI Agent Instructions

## Purpose

Every repository that adopts the Pages system should include a concise `AGENTS.md` that tells an AI agent how to find and preserve its documentation system.

## Required guidance

An agent instruction file should state that:

- `README.md` is the repository entrypoint.
- `docs/` is the canonical detailed documentation and Pages source.
- Pages presentation files support documentation; they do not create a second content source.
- Navigation is maintained in one place.
- Existing documentation must be inspected before the kit is installed or reorganized.
- Audits and discovery do not grant edit, deployment, or publication authority.
- Changes to documentation structure, navigation, or public publication are reviewed deliberately.
- The applicable writing mode is selected before drafting prose or procedures.

## Standards lookup

When asked to add Pages from standards, an agent should locate the standards repository, read the Pages-related standards including `docs/documentation-writing-style.md`, inspect the consumer repository, and adapt `pages/github-pages-docs-site/` to the consumer's real structure. It must not blindly replace `docs/`, deploy Pages, or publish content without explicit direction.
