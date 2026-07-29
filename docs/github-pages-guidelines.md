# GitHub Pages Guidelines

## Purpose

GitHub Pages is the public presentation layer for repository documentation. It is not a second source of truth and it is not a replacement for repository Markdown.

Canonical documentation lives in the consumer repository's `docs/` directory. Pages renders that same material in a calm, navigable documentation shell.

## Repository documentation system

Use this structure as the default documentation system for repositories that
adopt Pages:

```text
Repository
│
├── README.md
│   └── introduction / purpose / quick orientation
│
├── docs/
│   └── GitHub Pages site
│       ├── deeper explanation
│       ├── visuals
│       ├── architecture
│       ├── timeline
│       └── supporting material
│
└── AGENTS.md
    └── project operating instructions
```

`README.md` is the GitHub-native front door. `docs/` is the canonical long-form
manual and the source rendered by Pages. `AGENTS.md` records the operating
instructions that keep the system understandable to both human and AI
contributors. These roles complement one another; none is a duplicate of the
others.

## Standard model

```text
README.md
    -> fast GitHub-native orientation
docs/
    -> canonical detailed documentation and Pages source
GitHub Pages
    -> public rendering of approved docs/ material
```

The Pages source, site configuration, layout, navigation data, and stylesheet are versioned with the project. Documentation changes remain ordinary diffs and should be reviewed with the project they describe.

## Layouts

The standard layout has:

- a small site identity area
- a direct page title and optional one-sentence purpose
- a readable main content column for rendered Markdown
- an on-page table of contents generated from the current page's `##` and `###` headings

Use the extended layout when a documentation set is large enough to need both forms of orientation:

- left-side project navigation, defined in one data file
- central rendered Markdown content
- right-side on-page table of contents generated from page headings

The project navigation answers “where am I in this manual?” The on-page table of contents answers “where am I in this document?” Do not confuse or duplicate the two.

Do not include wiki author metadata, revision counts, edit controls, new-page controls, or other authoring UI in the default presentation. Git history and pull requests remain the authoring and revision surface.

## Navigation and links

Extended-layout project navigation is defined once in a data file rather than recreated on each page. Keep it shallow, task-oriented, and limited to pages that exist. The standard layout does not require a project-navigation rail.

The on-page table of contents is generated from rendered headings. Use a direct page title and meaningful `##` headings; do not write a slogan as the page title and then make the first real section carry the document’s actual subject.

Use clear page titles and stable paths. Prefer relative links in Markdown so the same source works on GitHub and on Pages.

The README should link to the documentation home. Pages pages may link to the repository and to source files when doing so helps the reader, but Pages must not become a parallel manual.

## Markdown and tables

Use ordinary Markdown for headings, prose, lists, links, code, and tables. The shared stylesheet should make these elements readable without requiring page-specific design work.

All Markdown tables use one shared treatment: generous rows, subtle horizontal rules, a stronger header divider, and no bottom rule after the final data row. Do not introduce a second table class or an HTML-only table system unless a future documented need cannot be served by ordinary Markdown.

## Writing

Apply `docs/documentation-writing-style.md` when authoring orientation pages, field manuals, long-form technical chapters, or other documentation where the reader needs both context and procedure. Pages should extend Markdown-native writing, not replace it with product-site copy.

## Platform convention

The reusable kit uses Jekyll-compatible GitHub Pages conventions. Its `_layouts/`, `_includes/`, and `_data/` directories are platform-required directories inside the Pages source only. They are not a general repository organization convention and do not override the standards against introducing underscore support directories elsewhere.

## Publication boundary

Publishing Pages is a separate decision from writing documentation. Before deployment, review public content for OPSEC, sanitization, broken links, and whether the intended documentation is appropriate for public release.
