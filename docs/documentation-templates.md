# Documentation Templates

## Purpose

The Pages kit at `pages/github-pages-docs-site/` is a reusable starting point for a repository documentation site. It supplies presentation, navigation, and example content; it does not replace a project's actual documentation.

## Adoption workflow

1. Inspect the consumer repository and its existing README and `docs/` files.
2. Read the applicable README, Pages, wiki, and AI-instruction standards.
3. Copy the kit into the consumer repository without overwriting intentional documentation.
4. Adapt navigation and starter pages to the project's real structure.
5. Review the result as a normal diff.
6. Validate local rendering and links when appropriate.
7. Deploy only after the operator explicitly approves publication.

## Customization boundary

Projects may change site identity, navigation labels, accent color, content, and which sections exist. Preserve the core model: Markdown stays canonical, navigation is defined once, and CSS owns the shared visual language.

Do not add a separate wiki or copy detailed documentation into the README.

## Layout selection

Use the standard layout for ordinary pages. Its right rail is an automatically generated on-page table of contents.

Use the extended reference layout only when readers need a persistent project manual tree as well as an on-page table of contents. Do not add a navigation rail merely because a template provides one.

Choose the page’s writing mode—orientation, guide, or reference—using `docs/documentation-writing-style.md`.
