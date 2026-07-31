# Documentation Templates

## Purpose

The Pages kit at `pages/github-pages-docs-site/` is a reusable starting point for a repository documentation site. It supplies presentation, navigation, and example content; it does not replace a project's actual documentation.

Use `prompts/add-github-pages.md` for the complete adoption workflow, including the established-README migration path.

## Adoption workflow

1. Inspect the consumer repository and its existing README and `docs/` files.
2. Read the applicable README, Pages, wiki, and AI-instruction standards.
3. When an established README needs reshaping, snapshot it as `README.pre-pages.md` before changing it.
4. Promote the enduring narrative into `docs/index.md` and other canonical Pages content; rewrite the active README as the GitHub-native front door.
5. Copy the kit into the consumer repository without overwriting intentional documentation. Preserve its shared presentation files as a coherent kit; configure site identity, repository link, site context, and navigation through the intended data and configuration files rather than casually forking layouts, CSS, or the table-of-contents script.
6. Adapt navigation and starter pages to the project's real structure.
7. Review the result as a normal diff.
8. Validate local rendering and links when appropriate.
9. Deploy only after the operator explicitly approves publication.

## Customization boundary

Projects may change site identity, navigation labels, accent color, content, and which sections exist. Preserve the core model: Markdown stays canonical, navigation is defined once, and CSS owns the shared visual language.

When a consumer reveals a generally useful presentation improvement, update the
standards kit as part of the work rather than leaving an accidental one-project
fork. Keep a consumer-only presentation change only when it is genuinely
specific to that project.

Do not add a separate wiki or copy detailed documentation into the README.

## Layout selection

Use the standard layout for ordinary pages. Its right rail is an automatically generated on-page table of contents.

Use the extended reference layout only when readers need a persistent project manual tree as well as an on-page table of contents. Do not add a navigation rail merely because a template provides one.

Choose the page’s writing mode—orientation, guide, or reference—using `docs/documentation-writing-style.md`.

## Public project manual patterns

For a public project manual, choose only the pages the project can honestly
support. Useful patterns include:

- an overview that establishes the project’s claim and reading path
- a lifecycle or guide that explains the real workflow around the code
- architecture that explains the system shape and design constraints
- a scope-and-evidence page that distinguishes public claims, demonstrations,
  private work, and planned work
- artifacts and closure material when durable output, restoration, or review is
  part of the project’s meaning
- a synthetic demo or visual page when it can show the interface without
  exposing operational material
- a timeline or project record when milestones help the reader understand the
  project’s deliberate direction

These are information-architecture patterns, not mandatory boilerplate. Omit a
page that would only restate another page or imply evidence the project does
not have.
