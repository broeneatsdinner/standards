# Standards Repository Agent Instructions

This repository defines reusable engineering standards. Treat `docs/` as the canonical written authority, `prompts/` as AI-facing workflow material, and domain directories such as `shell/` and `pages/` as reusable implementation resources.

## Working rules

- Read the relevant standards before proposing or making changes.
- Keep discovery and audit work report-only unless the operator explicitly approves remediation.
- Preserve existing patterns and do not reorganize unrelated material.
- Do not commit, push, publish, delete, or deploy without explicit operator direction.
- When changing a standard, update direct indexes and references that describe the same system.

## Pages work

When a task concerns project documentation sites, read `docs/readme-guidelines.md`, `docs/github-pages-guidelines.md`, `docs/wiki-policy.md`, `docs/documentation-templates.md`, `docs/documentation-writing-style.md`, and `docs/ai-agent-instructions.md`.

The reusable implementation kit lives at `pages/github-pages-docs-site/`. It is copied into a consumer repository and adapted to that repository's real documentation. Do not treat this standards repository as a Pages deployment target merely because it contains the kit.
