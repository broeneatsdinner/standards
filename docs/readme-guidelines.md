# README Guidelines

## Purpose

`README.md` is the repository's front door. It should answer what the project is, why it exists, what a visitor can do next, and where detailed documentation lives.

The README is an orientation document, not a duplicate manual.

## Required shape

Most repositories should include:

1. project name and one-sentence description
2. purpose and primary artifact
3. quick start, use, or reading path appropriate to the repository
4. a link to detailed documentation in `docs/`
5. a concise map of meaningful top-level directories when structure matters

Use the repository taxonomy to calibrate detail. A tool repository emphasizes installation and use; a field manual emphasizes the operating practice; a research repository makes unfinished scope visible; a standards repository explains the authority it provides.

## Relationship to Pages

When a repository publishes GitHub Pages, the README remains the GitHub-native entrypoint. It should link to the published documentation and to the canonical `docs/` source, without reproducing the Pages navigation or every detailed page.

Write information once. Link or summarize it elsewhere.

## Adopting Pages in an established repository

When an existing README already carries substantial project narrative or
technical detail, create an adjacent snapshot named `README.pre-pages.md`
before restructuring it.

Promote the enduring narrative and detailed material into `docs/index.md` and
other appropriate canonical documentation pages. Then rewrite `README.md` as a
concise GitHub-native front door: what the repository is, its boundary, where
to begin, and where detailed documentation lives.

The snapshot is a migration record, not a second maintained manual. Do not
continue updating it after the migration. The new README and `docs/` pages are
the active documentation system.

## Keep it useful

- Lead with concrete language rather than generic claims.
- Keep commands, screenshots, and examples current.
- Do not add badges, boilerplate, or sections that do not help the reader.
- Prefer links into `docs/` over a long README that becomes a second manual.
