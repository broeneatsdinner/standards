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

## Public deployment

For an approved public repository, GitHub Pages is deployed through the
Actions-based workflow in the reusable kit. The workflow builds `docs/`, uploads
the rendered artifact, and deploys it to the `github-pages` environment. Do not
vendor Jekyll, a Ruby dependency tree, or generated site output into the
consumer repository.

Derive the owner and repository name from the configured GitHub `origin` remote.
For a standard project site, configure `docs/_config.yml` with the account URL
and project path:

```yaml
url: "https://<owner>.github.io"
baseurl: "/<repository>"
repository_url: "https://github.com/<owner>/<repository>"
```

`baseurl` is required for a project site. It makes `relative_url` references
resolve to paths such as `/operator-pipeline/assets/css/site.css` rather than to
the account-site root.

Enable the repository's Pages source as **GitHub Actions** only after the
operator has separately approved public deployment. GitHub Settings is the
normal activation surface; an authenticated Pages API call may perform the same
configuration when explicitly authorized.

After the deployment workflow succeeds, verify the rendered home and the
reader-facing routes. Only then replace the README's early manual link and
reader-facing chapter links with the verified Pages URLs. Until then, README
links should point to `docs/index.md` and related canonical Markdown files.

For private repositories and local-only manuals, do not add the deployment
workflow or activate Pages without explicit publication authorization.

## Kit integrity and project configuration

Copy the presentation support as one coherent kit: `_layouts/`, `_includes/`,
shared CSS, and the on-page table-of-contents script. Do not casually reformat,
minify, or fork those files while applying Pages to a project; incidental
consumer differences make later visual and accessibility fixes needlessly hard
to share.

Configure the project through `_config.yml`, navigation data, and authored
Markdown. Project configuration may set the site title, description,
`repository_url`, and an optional `site_context` label such as “Private working
documentation.” The header should render `site_context` when supplied;
otherwise it should render the configured repository link.

When a project needs a substantive improvement to the shared presentation,
first decide whether it belongs in the standards kit. Upstream a generally
useful improvement before or alongside consumer adoption; keep only genuinely
project-specific presentation changes in the consumer repository.

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

## Front matter and build validity

Jekyll front matter is YAML. Quote a title, summary, or other scalar that
contains a colon or YAML-significant punctuation. A build that prints a YAML
exception, warning, or malformed-page symptom is not a passing build merely
because Jekyll exits successfully.

Build into a fresh temporary directory and inspect the rendered home, an
ordinary page, and each newly added page. Confirm that each page has its title,
summary when expected, body content, navigation, and generated table of
contents. Treat a blank title, missing metadata, or omitted page as a
validation failure.

## Publication boundary

Publishing Pages is a separate decision from writing documentation. Before deployment, review public content for OPSEC, sanitization, broken links, and whether the intended documentation is appropriate for public release.
